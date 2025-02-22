extends CharacterBody2D
class_name Player

signal droplet_collected

@onready var sprite: Sprite2D = $Sprite

@export var speed = 700.0
@export var color := Color(1, 1, 1)
@export var player_id: int

var inverse_blend: bool = false
var inverse_score: bool = false
var direction: Vector2
var score: float

func _ready() -> void:
	sprite.material = sprite.material.duplicate()
	
	add_to_group("players")
	
	var events = get_node("/root/World/Events")
	if events:
		events.speed_up.connect(_on_speed_up)
		events.speed_down.connect(_on_speed_down)
		events.inverse_blend.connect(_on_inverse_blend)
		events.uno_reverse.connect(_on_uno_reverse)
		

func _process(_delta):
	# Movement
	direction.x = Input.get_axis("left%s" % [player_id], "right%s" % [player_id])
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)

	move_and_slide()
  # Color Handling
	sprite.material.set_shader_parameter("ColorParameter", color)

func _on_collection_area_entered(area: Area2D) -> void:
	if area.is_in_group("droplet"):
		var droplet = area.get_parent()
		var droplet_color: Color = droplet.color
		print("Droplet color", droplet_color)
		# Set color alpha
		color.a = 0.8
		droplet_color.a = 0.2
		# Blend and calculate the player's score
		if inverse_blend:
			color.r = max(0, color.r - droplet_color.r)
			color.g = max(0, color.g - droplet_color.g)
			color.b = max(0, color.b - droplet_color.b)
		else:
			color = color.blend(droplet_color)
		print("Score?:", Utils.get_deltaE(color, Globals.target_color) ** 2.8)
		print("Target color", Globals.target_color, "Current color", color)
		
		if inverse_score:
			Globals.player_scores[1-player_id] = 1000 - (Utils.get_deltaE(color, Globals.target_color) ** 2.8)
			Globals.player_colors[1-player_id] = color
		else:
			Globals.player_scores[player_id] = 1000 - (Utils.get_deltaE(color, Globals.target_color) ** 2.8)
			Globals.player_colors[player_id] = color
		
		droplet_collected.emit()
		# Free the object
		droplet.queue_free()

func _on_speed_up():
	speed = 2*speed
	
	get_tree().create_timer(3).timeout.connect(func(): 
		speed = speed/2
	)
	
func _on_speed_down():
	speed = speed/2
	
	get_tree().create_timer(1).timeout.connect(func(): 
		speed = speed*2
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
