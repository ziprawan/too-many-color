extends Node
class_name EventManager

#signal speed_up
#signal speed_down
#signal inverse_blend
#signal drought_limit
#signal dat_boi
#signal uno_reverse
#signal fall_fast
#signal fall_slow

#var game_manager : GameManager

@export var blindness_mask: Sprite2D

var active_event : Event
var active_event_timer : float

var cooldown_timer : float

#var can_trigger_event : bool = true
#var events = [
	#november_rain, made_in_heaven, made_in_hell, bohemian_rhapsody, drought, 
	#el_nino, c_moon, c_moon_2, reversal, blindness
#]
@export var events : Array[Event]

func _ready():
	for child in get_children():
		if child is Event:
			events.append(child)
	for player in get_tree().get_nodes_in_group("Player"):
		player.droplet_collected.connect(_on_droplet_collected)

func _process(delta : float):
	print(active_event_timer)
	# Event Timer
	if active_event_timer > 0: 
		active_event_timer -= delta
	elif active_event_timer <= 0:
		end_current_event()
	# Cooldown timer
	if cooldown_timer > 0: cooldown_timer -= delta
	
	# Trigger active event's per-frame code
	if active_event:
		active_event.update(delta)

func _on_droplet_collected():
	trigger_random_event()

func trigger_random_event():
	if not active_event and cooldown_timer <= 0: 
		start_event(events[randi() % events.size()])

func start_event(event : Event):
	active_event = event
	event.on_triggered()
	active_event_timer = event.duration

func end_current_event():
	if active_event: 
		active_event.on_end()
		cooldown_timer = active_event.cooldown_duration
	active_event = null
	pass

#func november_rain(): 
	#droplet_timer.wait_time = 0.1
	#cooldown(2.0)
	#
#func made_in_heaven():
	#speed_up.emit()
	#cooldown(3.0)
#
#func made_in_hell():
	#speed_down.emit()
	#cooldown(1.0)
#
#func bohemian_rhapsody():
	#inverse_blend.emit()
	#cooldown(5.0)
	#
#func drought():
	#droplet_timer.wait_time = 2
	#drought_limit.emit()
	#cooldown(2.0)
#
#func el_nino():
	#dat_boi.emit()
	#cooldown(1.0)
	#
#func c_moon():
	#fall_fast.emit()
	#cooldown(2.0)
#
#func c_moon_2():
	#fall_slow.emit()
	#cooldown(2.0)
#
#func reversal():
	#uno_reverse.emit()
	#cooldown(5.0)
	#
#func blindness():
	#if not blindness_mask: return
	#blindness_mask.Visible = true
	#cooldown(5.0)
#
#func _on_event_cooldown_timeout():
	#droplet_timer.wait_time = original_droplet_cooldown
	#can_trigger_event = true
	#blindness_mask.Visible = false
	#
#func cooldown(duration:float):
	#event_cooldown.wait_time = duration
	#event_cooldown.start()
