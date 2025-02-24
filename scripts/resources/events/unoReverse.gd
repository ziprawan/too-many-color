extends Event
class_name UnoReverse

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("uno_reverse")

func on_end():

	EventBus.emit_signal("uno_reverse")
