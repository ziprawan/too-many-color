class_name OptionsMenu
extends Control

@export var volume_slider : Slider
@export var round_duration_slider : Slider
@export var rounds_per_set_slider : Slider

@export var exit_button : Button
signal exit_options_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	exit_button.button_down.connect(_on_exit_button_pressed)
	set_process(false)

func _on_exit_button_pressed() -> void:
	exit_options_menu.emit()
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_PRESS)
	
	# Applies setting changes
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(volume_slider.value/100))
	Globals.round_duration = round_duration_slider.value
	Globals.rounds_per_set = rounds_per_set_slider.value
	set_process(false)
