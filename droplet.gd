extends CharacterBody2D

@export var speed = 300
@export var spawn: Vector2

func _ready():
	global_position = spawn

func _process(_delta):
	velocity = Vector2(0,speed)
	move_and_slide()


func _on_area_2d_body_entered(body):
	print("ding")
	queue_free()
