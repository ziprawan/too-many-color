extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite

@export var starting_position : Vector2
@export var speed = 700.0
@export var color := Color(1, 1, 1)
@export var player_id: int

var direction : Vector2
var score : float :
	# Updates the value in game_manager as well
	set(value):
		game_manager.player_scores[player_id] = value
		score = value
var set_score : float :
	set(value):
		game_manager.player_set_scores[player_id] = value
		set_score = value

var game_manager : GameManager

func _ready() -> void:
	game_manager = get_tree().current_scene
	game_manager.round_start.connect(on_round_start)
	game_manager.round_end.connect(on_round_end)
	game_manager.set_start.connect(on_set_start)
	game_manager.set_end.connect(on_set_end)
	sprite.material = sprite.material.duplicate()

func _process(_delta):
	# Movement Handling
	direction.x = Input.get_axis("left%s" % [player_id], "right%s" % [player_id])
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
	move_and_slide()
	
	# Color Handling
	sprite.material.set_shader_parameter("ColorParameter", color)

func on_round_start(round_number):
	print("round ", round_number," start!")
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

		print("Droplet color", droplet_color)

		# Set color alpha
		color.a = 0.8
		droplet_color.a = 0.2

		# Blend and calculate the player's score
		color = color.blend(droplet_color)
		score = 1000 - (Utils.get_deltaE(color, game_manager.current_target_color) ** 3.58)
		game_manager.player_dE[player_id] = Utils.get_deltaE(color, game_manager.current_target_color)

		# Free the object
		droplet.queue_free()
