extends Event
class_name NovemberRain

@export_range(1, 9) var ratio : float

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("change_droplet_rate", ratio)

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("change_droplet_rate", 1/ratio)
