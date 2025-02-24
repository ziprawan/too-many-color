extends Node2D
class_name DropletGenerator

@onready var main = get_tree().current_scene
@onready var projectile = load("res://scenes/objects/droplet.tscn")

@export var droplet_delay = 0.5:
	set(value):
		rain_timer.wait_time = value
		droplet_delay = value
@export var speed_range = Vector2(450, 650)
@export var point_l: Marker2D
@export var point_r: Marker2D
@export var height: float
@export var min_droplet: int = 1
@export var max_droplet: int = 3
@export_category("Dependencies")
@export var event_manager: EventManager
@export var rain_timer: Timer
var can_generate: bool = false

func _ready():
	rain_timer.wait_time = droplet_delay
	EventBus.connect("change_droplet_rate", change_droplet_rate)
	EventBus.connect("reduce_droplet_count", reduce_droplet_count)
	EventBus.connect("change_droplet_velocity", change_droplet_velocity)
	EventBus.connect("countdown_over", func(): can_generate = true)
	EventBus.connect("game_over", on_game_over)
	EventBus.connect("dat_boi", on_el_nino)

func rain():
	var count = randi_range(min_droplet, max_droplet)
	var x_coords = randf_range(point_l.global_position.x, point_r.global_position.x)
	
	for i in range(count):
		var last_coords = x_coords
		x_coords = randf_range(point_l.global_position.x, point_r.global_position.x)
		
		if last_coords == x_coords:
			x_coords = last_coords + randf_range(-200, 200)

		# Droplet Instantiation
		if can_generate:
			var instance: Droplet = projectile.instantiate()
			instance.spawn_position = Vector2(x_coords, height)
			instance.speed = randi_range(speed_range.x, speed_range.y)
			if randf() <= 0.05:
				instance.scale = Vector2(2.0, 2.0)
			main.add_child.call_deferred(instance)

func change_droplet_rate(ratio: float):
	droplet_delay *= 1 / ratio
	print("droplet delay: ", droplet_delay)

func reduce_droplet_count(n: int):
	min_droplet = max(0, min_droplet - n)
	max_droplet = max(min_droplet, max_droplet - n)
	pass
#Ketika sudah kelar, drplet generator stop
func on_game_over():
	can_generate = false # Menghentikan generator droplet
	rain_timer.stop() # Menghentikan timer
#func _on_drought_limit():
	#max_droplet = 1
	#get_tree().create_timer(2).timeout.connect(func():
		#max_droplet = 3
	#)
#
#func _on_el_nino():
	#min_droplet = 0
	#max_droplet = 0
	#get_tree().create_timer(1).timeout.connect(func():
		#min_droplet = 1
		#max_droplet = 3
	#)
	#
#func _on_c_moon():
	#speed_range = Vector2(225, 325)
	#get_tree().create_timer(2).timeout.connect(func():
		#speed_range = Vector2(450, 650)
	#)
#
#func _on_c_moon_2():
	#speed_range = Vector2(900, 1300)
	#get_tree().create_timer(2).timeout.connect(func():
		#speed_range = Vector2(450, 650)
	#)


func change_droplet_velocity(speed: float):
	speed_range *= speed
	
func on_el_nino():
	can_generate = not can_generate

func _on_timer_timeout() -> void:
	rain()
