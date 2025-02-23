extends Event
class_name MadeInHell

@export_range(0.1, 1) var ratio : float = 0.5

func on_triggered():
	#print(self, " triggered")
	EventBus.emit_signal("change_player_move_speed", ratio)

func on_end():
	#print(self, " ended")
	EventBus.emit_signal("change_player_move_speed", 1/ratio)
