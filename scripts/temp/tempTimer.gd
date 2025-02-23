extends RichTextLabel
class_name TempTimerDisplay

var game_manager : GameManager

func _ready() -> void:
	game_manager = get_tree().current_scene

func _process(delta: float) -> void:
	var timer_string : String
	if game_manager.round_timer >= 10.0:
		timer_string = str(roundi(game_manager.round_timer))
	else: timer_string = str(Utils.round_to_dec(game_manager.round_timer, 1))

	text = str("[center]", timer_string)
