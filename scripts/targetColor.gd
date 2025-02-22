extends Sprite2D
class_name TargetColor

# This script is not temporary
var game_manager: GameManager
var color: Color = Color(1, 1, 1):
	set(value):
		game_manager.current_target_color = value
		color = value

func _ready() -> void:
	game_manager = get_tree().current_scene
	game_manager.round_start.connect(on_round_start)
	material.set_shader_parameter("ColorParameter", game_manager.current_target_color)

func on_round_start(_round_number):
	randomise_color()

func randomise_color():
	color = Color.from_hsv(randf_range(0, 1), randf_range(0.3, 0.58), randf_range(0.5, 1), 1)
	material.set_shader_parameter("ColorParameter", color)
