extends Node2D
class_name BackgroundManager

@export var recolor_material : ShaderMaterial
@export var sprite_groups : Array[Sprite2D]

func _ready():
	EventBus.change_background_color.connect(add_recolor_material)

func add_recolor_material(group_idx : int, color : Color):
	if group_idx < sprite_groups.size():
		var target_group = sprite_groups[group_idx]
		target_group.material = recolor_material
		target_group.material = target_group.material.duplicate()
		target_group.material.set_shader_parameter("ColorParameter", color)
	pass
