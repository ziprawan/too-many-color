extends Event
class_name Drought

@export_range(1, 5) var reduce_by : int = 1

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("reduce_droplet_count", reduce_by)

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("reduce_droplet_count", -reduce_by)
