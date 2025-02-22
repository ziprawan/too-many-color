extends Node
class_name GameManager

@export var target_color_indicator: Sprite2D

func _ready() -> void:
  target_color_indicator.material.set_shader_parameter("ColorParameter", Globals.target_color)
  print(OS.is_debug_build())
