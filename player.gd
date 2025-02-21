extends CharacterBody2D

var direction: Vector2
@export var speed = 700.0
@export var playerID = 1

	
func _process(_delta):
	direction.x = Input.get_axis("left%s"% [playerID],"right%s" % [playerID])
	if direction:
		velocity = direction * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, speed)
		
	
	move_and_slide()
