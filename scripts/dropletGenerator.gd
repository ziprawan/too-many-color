extends Node2D

@onready var main = get_tree().current_scene
@onready var projectile = load("res://scenes/objects/droplet.tscn")
@export var speed_range = Vector2(300, 650)
@export var point_1: float
@export var point_2: float
@export var height: float
@export var min_droplet: int = 1
@export var max_droplet: int = 3

func rain():
	var count = randi_range(min_droplet, max_droplet)
	var coords = randf_range(point_1, point_2)

	for i in range(count):
		var last_coords = coords

		if last_coords == coords:
			coords = last_coords + randf_range(100, 300)
			
		# Droplet Instantiation
		var instance: Droplet = projectile.instantiate()
		instance.spawn_position = Vector2(coords, height)
		instance.speed = randi_range(speed_range.x, speed_range.y)
		main.add_child.call_deferred(instance)

func _on_timer_timeout() -> void:
	rain()
