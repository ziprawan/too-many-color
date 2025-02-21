extends CharacterBody2D
class_name Droplet

@export var speed = 300
@export var spawn_position : Vector2
@export var color : Color
@onready var sprite: Sprite2D = $Sprite

func _ready():
	sprite.material = sprite.material.duplicate()
	color = Color.from_hsv(randf_range(0, 1), randf_range(0, 0.4), randf_range(0.7, 1), 1) # Pastel
	#color = Color.from_hsv(randf_range(0, 1), randf_range(0, 1), randf_range(0, 1), 1) # Full Range
	sprite.material.set_shader_parameter("ColorParameter", color)
	global_position = spawn_position

func _process(_delta):
	velocity = Vector2(0, speed)
	move_and_slide()
