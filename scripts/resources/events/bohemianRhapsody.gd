extends Event
class_name BohemianRhapsody

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("toggle_inverse_blend")

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("toggle_inverse_blend")
