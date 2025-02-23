extends CharacterBody2D
class_name Player

signal droplet_collected

@onready var animated_sprite: AnimatedSprite2D = $CharacterSprite
@onready var bucket: Sprite2D = $Bucket
@onready var bucket_2: Sprite2D = $Bucket2

@export var speed = 500.0
@export var color := Color(1, 1, 1)
@export var player_id: int
@export var water_sprite: Sprite2D

var starting_position: Vector2
var direction: Vector2
var inverse_blend: bool = false
var inverse_score: bool = false
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
var phase:int = 1

func _ready() -> void:
	game_manager = get_tree().current_scene

	# player_id validation
	if player_id > 1 or player_id < 0:
		push_error("player_id value can only be 0 or 1")
	
	
	# EventBus set/round shenanigans
	EventBus.round_start.connect(on_round_start)
	EventBus.round_end.connect(on_round_end)
	EventBus.set_start.connect(on_set_start)
	EventBus.set_end.connect(on_set_end)
	# In-game Events shenanigans
	EventBus.change_player_move_speed.connect(change_move_speed)
	EventBus.toggle_inverse_blend.connect(toggle_inverse_blend)
	
	water_sprite.material = water_sprite.material.duplicate()
	starting_position = global_position

func _process(_delta):
	# Movement Handling
	direction.x = Input.get_axis("left%s" % [player_id], "right%s" % [player_id])
	if direction:
		velocity = direction * speed
		animated_sprite.play("walk_phase_%d_%d"% [phase, player_id])
		if direction.x < 0:
			animated_sprite.flip_h = true
		elif direction.x > 0:
			animated_sprite.flip_h = false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		animated_sprite.play("idle_phase_%d_%d"% [phase, player_id])
	move_and_slide()

	# Color Handling
	water_sprite.material.set_shader_parameter("ColorParameter", color)

func on_round_start(round_number):
	if game_manager.player_set_tally[player_id] > 0 :
		phase = 2
		bucket_2.visible = true
		bucket.visible = false
	else:
		bucket.visible = true
		bucket_2.visible = false
		
		
	print("round ", round_number, " start!")
	pass

func on_round_end():
	print("round end!")
	set_score += score
	color = Color(1, 1, 1)
	global_position = starting_position
	pass

func on_set_start(set_number):
	print("set ", set_number, " started!")
	set_score = 0
	pass

func on_set_end():
	pass

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
			#color.r = max(0, color.r - droplet_color.r)
			#color.g = max(0, color.g - droplet_color.g)
			#color.b = max(0, color.b - droplet_color.b)
			droplet_color.r = 1 - droplet_color.r
			droplet_color.g = 1 - droplet_color.g
			droplet_color.b = 1 - droplet_color.b
		color = color.blend(droplet_color)

		# Debug purpose
		Globals.player_colors[(1 - player_id) if inverse_score else player_id] = color

		droplet_collected.emit()

		# Free the object
		droplet.queue_free()

func change_move_speed(ratio : float):
	speed *= ratio

func toggle_inverse_blend():
	inverse_blend = not inverse_blend

#func _on_speed_up():
	#speed = 2 * speed
#
	#get_tree().create_timer(3).timeout.connect(func():
		#speed = speed / 2
	#)
#
#func _on_speed_down():
	#speed = speed / 2
#
	#get_tree().create_timer(1).timeout.connect(func():
		#speed = speed * 2
	#)
#
#func _on_uno_reverse():
	#inverse_score = true
#
	#get_tree().create_timer(5).timeout.connect(func():
		#inverse_score = false
	#)
#
#func _on_inverse_blend():
	#inverse_blend = true
#
	#get_tree().create_timer(5).timeout.connect(func():
		#inverse_blend = false
	#)
