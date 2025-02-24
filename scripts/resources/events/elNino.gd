extends Event
class_name ElNino

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("dat_boi")

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("dat_boi")
