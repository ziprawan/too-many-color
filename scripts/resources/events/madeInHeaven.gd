extends Event
class_name MadeInHeaven

@export_range(1.1, 3) var ratio : float = 5

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("change_player_move_speed", ratio)

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("change_player_move_speed", 1/ratio)
