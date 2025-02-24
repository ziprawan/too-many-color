extends Event
class_name CMoon

@export_range(2,3 ) var speed : float = 2

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("change_droplet_velocity",1/speed)

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("change_droplet_velocity",speed)
