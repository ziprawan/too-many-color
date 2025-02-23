extends CharacterBody2D
class_name Player

signal droplet_collected

@onready var animated_sprite: AnimatedSprite2D = $CharacterSprite
@onready var bucket: Sprite2D = $Bucket
@onready var bucket_2: Sprite2D = $Bucket2
@onready var water_sprite: Sprite2D = $Water
@onready var droplet_sfx: AudioStreamPlayer2D = $dropletSFX
@onready var walking_sfx: AudioStreamPlayer2D = $walkingSFX

@export var speed = 500.0
@export var color := Color(1, 1, 1) :
	set(value):
		game_manager.player_colors[player_id] = value
		color = value
@export var player_id: int


var starting_position: Vector2
var direction: Vector2
var inverse_blend: bool = false
var inverse_score: bool = false
var animation_lock:bool = false
var score: float:
	# Updates the value in game_manager as well
	set(value):
		game_manager.player_scores[(1 - player_id) if inverse_score else player_id] = value
		score = value
var set_score: float:
	set(value):
		game_manager.player_set_scores[player_id] = value
		set_score = value

var game_manager: GameManager
var can_move: bool = false
var prev_score:int
var phase:int = 1

func _ready() -> void:
	game_manager = get_tree().current_scene

	# player_id validation
	if player_id > 1 or player_id < 0:
		push_error("player_id value can only be 0 or 1")
		
	prev_score = game_manager.player_set_tally[player_id]
	
	# EventBus set/round shenanigans
	EventBus.round_start.connect(on_round_start)
	EventBus.round_end.connect(on_round_end)
	EventBus.set_start.connect(on_set_start)
	EventBus.set_end.connect(on_set_end)
	EventBus.game_over.connect(on_game_over)
	# In-game Events shenanigans
	EventBus.change_player_move_speed.connect(change_move_speed)
	EventBus.toggle_inverse_blend.connect(toggle_inverse_blend)
	
	#Countdown already over?
	EventBus.connect("countdown_over", func(): can_move = true)

	water_sprite.material = water_sprite.material.duplicate()
	starting_position = global_position

func _process(_delta):
	if animation_lock:
		return
	# Movement Handling
	direction.x = Input.get_axis("left%s" % [player_id], "right%s" % [player_id])
	
	if direction:
		velocity = direction * speed
		animated_sprite.play("walk_phase_%d_%d"% [phase, player_id])
		walking_sfx.pitch_scale = randf_range(0.8,1.2)
		walking_sfx.play()
		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		animated_sprite.play("idle_phase_%d_%d"% [phase, player_id])

	if can_move:
		move_and_slide()
	

	# Color Handling
	water_sprite.material.set_shader_parameter("ColorParameter", color)
	#print(water_sprite.material.get_shader_parameter("ColorParameter"))
	#bucket.material.set_shader_parameter("ColorParameter", color)

func on_round_start(round_number):

	color = Color(1, 1, 1)
	print("round ", round_number, " start!")
	pass
#Ketika sudah menang, player ga bisa gerak lagi
func on_game_over():
	can_move = false  # Menghentikan pergerakan pemain
	print("Game over! Player ", player_id, " has stopped moving.")

func on_round_end():
	print("round end!")
	set_score += score
	score = 0
	global_position = starting_position
	pass

func on_set_start(set_number):
	if game_manager.player_set_tally[player_id] > prev_score :
		phase = min(4,phase+1)
		bucket_2.visible = true
		bucket.visible = false
	else:
		bucket.visible = true
		bucket_2.visible = false
	print("set ", set_number, " started!")
	set_score = 0
	pass

func on_set_end():
	animation_lock = true
	if game_manager.player_set_tally[player_id] > game_manager.player_set_tally[1-player_id]:
		animated_sprite.play("win_%d"%player_id)
	else:
		animated_sprite.play("lose")

func _on_collection_area_entered(area: Area2D) -> void:
	if area.is_in_group("droplet"):
		var droplet = area.get_parent()
		var droplet_color: Color = droplet.color

		#print("Droplet color", droplet_color)

		# Set color alpha
		color.a = 0.8
		droplet_color.a = 0.2

		# Blend and calculate the player's score
		color = color.blend(droplet_color)
		score = 1000 - (Utils.get_deltaE(color, game_manager.current_target_color) ** 3.38)
		game_manager.player_dE[player_id] = Utils.get_deltaE(color, game_manager.current_target_color)

		if inverse_blend:
			droplet_color.r = 1 - droplet_color.r
			droplet_color.g = 1 - droplet_color.g
			droplet_color.b = 1 - droplet_color.b
		color = color.blend(droplet_color)

		# Debug purpose
		Globals.player_colors[(1 - player_id) if inverse_score else player_id] = color
		droplet_sfx.play()
		droplet_collected.emit()

		# Free the object
		droplet.queue_free()

func change_move_speed(ratio : float):
	speed *= ratio

func unfreeze_player_movement():
	pass

func toggle_inverse_blend():
	inverse_blend = not inverse_blend
