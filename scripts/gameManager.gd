extends Node
class_name GameManager

# Round / Set Shenanigans
@export var round_duration: float = 25
var round_timer: float
var round_is_active: bool = true
var round_per_set := 4
var set_per_game = 7
var current_round = 0
var current_set = 0
#signal round_start(round_number: int)
#signal round_end
#signal set_start(set_number: int)
#signal set_end
#signal game_over

# Game Variables
var current_target_color: Color
@export var player_scores := [0.0, 0.0]
@export var player_set_scores := [0.0, 0.0]
@export var player_set_tally = [0, 0]
var player_dE = [0.0, 0.0]

func _ready() -> void:
	start_next_round()

func start_next_round():
	current_round += 1
	if current_round > round_per_set: start_new_set()
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
	# Determines who gets the point
	if player_set_scores[0] > player_set_scores[1]: player_set_tally[0] += 1
	else: player_set_tally[1] += 1
	# Start new set
	current_round = 0
	current_set += 1
	if current_set < set_per_game:
		EventBus.set_start.emit(current_set)
		start_next_round()
	else:
		EventBus.game_over.emit() # nnti bisa ditambahin game over logic, for now it doesnt do anything

func _process(delta: float) -> void:
	if round_timer - delta >= 0:
		round_timer -= delta
	elif round_is_active:
		round_timer = 0
		end_round()
