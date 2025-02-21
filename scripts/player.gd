extends CharacterBody2D
class_name Player

var direction: Vector2
@export var speed = 700.0
@export var player_id = 2
@export var color := Color(1, 1, 1)
var score : float
@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	sprite.material = sprite.material.duplicate()

func _process(_delta):
	# Movement
	direction.x = Input.get_axis("left%s"% [player_id],"right%s" % [player_id])
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
		var droplet_color : Color = droplet.color
		print(droplet_color)
		color.a = 0.8
		droplet_color.a = 0.2
		color = color.blend(droplet_color)
		droplet.queue_free()
		pass
