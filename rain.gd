extends Node2D

@onready var main = get_tree().get_root().get_node("World")
@onready var projectile = load("res://droplet.tscn")
@export var point1 : float
@export var point2 : float
@export var height: float
@export var mindroplet: int
@export var maxdroplet: int

func rain():
	var count = randi_range(mindroplet, maxdroplet)
	var coords = randf_range(point1, point2)	
	for i in range(count):
		var lastcoords = coords
		if lastcoords == coords:
			coords = lastcoords+randf_range(100,300)
		var instance = projectile.instantiate()
		instance.spawn = Vector2(coords, height)
		main.add_child.call_deferred(instance)

func _on_timer_timeout() -> void:
	rain()
