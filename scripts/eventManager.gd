extends Node
class_name EventManager

var active_event : Event
var active_event_timer : float

var cooldown_timer : float
@export var events : Array[Event]

func _ready():
	for child in get_children():
		if child is Event:
			events.append(child)
	for player in get_tree().get_nodes_in_group("Player"):
		player.droplet_collected.connect(_on_droplet_collected)

func _process(delta : float):
	#print(active_event_timer)
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
	if randf() <= 0.05:
		trigger_random_event()

func trigger_random_event():
	if not active_event and cooldown_timer <= 0: 
		start_event(events[randi() % events.size()])

func start_event(event : Event):
	active_event = event
	EventBus.event_started.emit(event)
	event.on_triggered()
	active_event_timer = event.duration

func end_current_event():
	if active_event: 
		active_event.on_end()
		cooldown_timer = active_event.cooldown_duration
	active_event = null
	pass
