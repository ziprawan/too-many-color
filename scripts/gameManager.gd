extends Node
class_name GameManager

# Round / Set Shenanigans
@export var round_duration: float = 60

var round_timer: float
var round_is_active: bool = true
var round_per_set := 1
var set_per_game = 7
var current_round = 0
var current_set = 0
var time_start:bool = false
#signal round_start(round_number: int)
#signal round_end
#signal set_start(set_number: int)
#signal set_end
#signal game_over

# Game Variables
var current_target_color: Color
var player_colors : Array[Color] = [Color(0, 0, 0), Color(0, 0, 0)]
@export var player_scores := [0.0, 0.0]
@export var player_set_scores := [0.0, 0.0]
@export var player_set_tally = [0, 0]
var player_dE = [0.0, 0.0]

func _ready() -> void:
	EventBus.connect("countdown_over", func(): time_start = true)
	start_next_round()

func start_next_round():
	if is_game_over():
		return
	
	current_round += 1
	if current_round > round_per_set:
		start_new_set()
	else:
		round_is_active = true
		round_timer = round_duration
		EventBus.round_start.emit(current_round)

func end_round():
	if round_is_active:
		round_is_active = false
		EventBus.round_end.emit()
		start_next_round()

func start_new_set():
	if is_game_over():
		return
	
	# Determines who gets the point
	if player_set_scores[0] > player_set_scores[1]: player_set_tally[0] += 1
	else: player_set_tally[1] += 1
	
	# Background color logic
	if player_set_tally[0] != player_set_tally[1]:
		var winner_id = player_set_tally.find(max(player_set_tally[0], player_set_tally[1]))
		EventBus.change_background_color.emit(max(player_set_tally[0], player_set_tally[1]), player_colors[winner_id])
	
	# Start new set
	current_round = 0
	current_set += 1
	if current_set < set_per_game:
		EventBus.set_start.emit(current_set)
		start_next_round()
	else:
		EventBus.game_over.emit() # nnti bisa ditambahin game over logic, for now it doesnt do anything

func _process(delta: float) -> void:
	if is_game_over():
		return
	
	if round_timer - delta >= 0:
		if time_start:
			round_timer -= delta
	elif round_is_active:
		round_timer = 0
		end_round()

func is_game_over() -> bool:
	# Check if any player has won 4 sets
	if player_set_tally[0] >= 4 or player_set_tally[1] >= 4:
		round_is_active = false
		time_start = false
		EventBus.game_over.emit()
		return true
	return false