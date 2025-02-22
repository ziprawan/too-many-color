extends CharacterBody2D
class_name Player

signal droplet_collected

@onready var sprite: Sprite2D = $Sprite

@export var speed = 700.0
@export var color := Color(1, 1, 1)
@export var player_id: int

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

func _ready() -> void:
	# player_id validation
	if player_id > 1 or player_id < 0:
		push_error("player_id value can only be 0 or 1")

	game_manager = get_tree().current_scene
	game_manager.round_start.connect(on_round_start)
	game_manager.round_end.connect(on_round_end)
	game_manager.set_start.connect(on_set_start)
	game_manager.set_end.connect(on_set_end)
	sprite.material = sprite.material.duplicate()
	
	starting_position = global_position

	add_to_group("players")

	var events = get_node("/root/Worlds/Events")
	if events:
		events.speed_up.connect(_on_speed_up)
		events.speed_down.connect(_on_speed_down)
		events.inverse_blend.connect(_on_inverse_blend)
		events.uno_reverse.connect(_on_uno_reverse)

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

		print("Droplet color", droplet_color)

		# Set color alpha
		color.a = 0.8
		droplet_color.a = 0.2

		# Blend and calculate the player's score
		color = color.blend(droplet_color)
		score = 1000 - (Utils.get_deltaE(color, game_manager.current_target_color) ** 3.58)
		game_manager.player_dE[player_id] = Utils.get_deltaE(color, game_manager.current_target_color)

		if inverse_blend:
			color.r = max(0, color.r - droplet_color.r)
			color.g = max(0, color.g - droplet_color.g)
			color.b = max(0, color.b - droplet_color.b)
		else:
			color = color.blend(droplet_color)

		# Debug purpose
		Globals.player_colors[(1 - player_id) if inverse_score else player_id] = color

		droplet_collected.emit()

		# Free the object
		droplet.queue_free()

func _on_speed_up():
	speed = 2 * speed

	get_tree().create_timer(3).timeout.connect(func():
		speed = speed / 2
	)

func _on_speed_down():
	speed = speed / 2

	get_tree().create_timer(1).timeout.connect(func():
		speed = speed * 2
	)

func _on_uno_reverse():
	inverse_score = true

	get_tree().create_timer(5).timeout.connect(func():
		inverse_score = false
	)

func _on_inverse_blend():
	inverse_blend = true

	get_tree().create_timer(5).timeout.connect(func():
		inverse_blend = false
	)
