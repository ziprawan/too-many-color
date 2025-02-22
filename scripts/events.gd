extends Node


signal speed_up
signal speed_down
signal inverse_blend
signal drought_limit
signal dat_boi
signal uno_reverse
signal fall_fast
signal fall_slow

@onready var event_cooldown:Timer = $EventCooldown
@export var droplet_timer:Timer
@export var blindness_mask: Sprite2D
@onready var original_droplet_cooldown = droplet_timer.wait_time
var trigger_event:bool = true
var events = [
	november_rain, made_in_heaven, made_in_hell, bohemian_rhapsody, drought, 
	el_nino, c_moon, c_moon_2, reversal, blindness
]

func _ready():
	for player in get_tree().get_nodes_in_group("players"):
		player.droplet_collected.connect(_on_droplet_collected)

func _on_droplet_collected():
	trigger_random_event()

func trigger_random_event():
	if trigger_event:
		trigger_event = false
		var random_index = randi() % events.size()
		events[random_index].call()
		
func cooldown(duration:float):
	event_cooldown.wait_time = duration
	event_cooldown.start()
	
func november_rain(): 
	droplet_timer.wait_time = 0.1
	cooldown(2.0)
	
func made_in_heaven():
	speed_up.emit()
	cooldown(3.0)

func made_in_hell():
	speed_down.emit()
	cooldown(1.0)

func bohemian_rhapsody():
	inverse_blend.emit()
	cooldown(5.0)
	
func drought():
	droplet_timer.wait_time = 2
	drought_limit.emit()
	cooldown(2.0)

func el_nino():
	dat_boi.emit()
	cooldown(1.0)
	
func c_moon():
	fall_fast.emit()
	cooldown(2.0)

func c_moon_2():
	fall_slow.emit()
	cooldown(2.0)

func reversal():
	uno_reverse.emit()
	cooldown(5.0)
	
func blindness():
	blindness_mask.Visible = true
	cooldown(5.0)
		

func _on_event_cooldown_timeout():
	droplet_timer.wait_time = original_droplet_cooldown
	trigger_event = true
	blindness_mask.Visible = false
	
