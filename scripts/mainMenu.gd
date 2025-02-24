class_name MainMenu
extends Control

@export var buttons_panel : Panel
@export var game_title_label : RichTextLabel
@export var start_button: Button
@export var options_button: Button
@export var exit_button: Button

@onready var options_menu: OptionsMenu = $OptionsMenu

func _ready() -> void:
	handle_connecting_signals()

func handle_connecting_signals() -> void:
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func _on_start_pressed() -> void:
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_PRESS)
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed() -> void:
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_PRESS)
	buttons_panel.visible = false
	game_title_label.visible  = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_exit_pressed() -> void:
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_PRESS)
	get_tree().quit()

func on_exit_options_menu() -> void:
	game_title_label.visible = true
	buttons_panel.visible = true
	options_menu.visible = false

func _on_multiplayerbutton_pressed() -> void:
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_PRESS)
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_button_mouse_entered() -> void:
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_HOVER)
