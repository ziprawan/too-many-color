extends Node2D

@onready var main = get_tree().current_scene
@onready var projectile = load("res://scenes/objects/droplet.tscn")
@onready var events = get_node("/root/World/Events")
@export var speed_range = Vector2(450, 650)
@export var point_1: float
@export var point_2: float
@export var height: float
@export var min_droplet: int = 1
@export var max_droplet: int = 3


func _ready():
	if events:
		events.drought_limit.connect(_on_drought_limit)
		events.dat_boi.connect(_on_el_nino)
		events.fall_fast.connect(_on_c_moon)
		events.fall_slow.connect(_on_c_moon_2)

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

func _on_drought_limit():
	max_droplet = 1
	get_tree().create_timer(2).timeout.connect(func(): 
		max_droplet = 3
	)

func _on_el_nino():
	min_droplet = 0
	max_droplet = 0
	get_tree().create_timer(1).timeout.connect(func():
		min_droplet = 1
		max_droplet = 3
	)
	
func _on_c_moon():
	speed_range = Vector2(225, 325)
	get_tree().create_timer(2).timeout.connect(func():
		speed_range = Vector2(450, 650)
	)

func _on_c_moon_2():
	speed_range = Vector2(900, 1300)
	get_tree().create_timer(2).timeout.connect(func():
		speed_range = Vector2(450, 650)
	)

	
func _on_timer_timeout() -> void:
	rain()
