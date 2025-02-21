extends Node
class_name GameManager

var target_color : Color
@export var target_color_indicator : Sprite2D

func _ready() -> void:
	target_color = Color.from_hsv(randf_range(0, 1), randf_range(0, 0.48), randf_range(0.65, 1), 1)
	target_color_indicator.material.set_shader_parameter("ColorParameter", target_color)

func _process(delta: float) -> void:
	pass
