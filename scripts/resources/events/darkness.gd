extends Event
class_name Darkness

@onready var blindness_mask = $Blindness

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("darkness")
	blindness_mask.visible = true

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("darkness")
	blindness_mask.visible = false
