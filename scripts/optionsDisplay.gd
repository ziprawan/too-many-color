extends HBoxContainer
class_name OptionsDisplay

@export var slider : Slider
@export var suffix : String
@export var label : Label

func _process(delta: float) -> void:
	label.text = str(slider.value, suffix)
	pass
