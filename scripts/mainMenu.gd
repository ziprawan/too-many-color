class_name MainMenu
extends Control

@onready var vbox_container: VBoxContainer = $VBoxContainer
@onready var start_button: Button = $VBoxContainer/StartButton
@onready var options_button: Button = $VBoxContainer/OptionsButton
@onready var exit_button: Button = $VBoxContainer/ExitButton

@onready var options_menu: OptionsMenu = $OptionsMenu

func _ready() -> void:
	handle_connecting_signals()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_options_pressed() -> void:
	vbox_container.visible = false
	options_menu.set_process(true)
	options_menu.visible = true

func _on_exit_pressed() -> void:
	get_tree().quit()

func on_exit_options_menu() -> void:
	vbox_container.visible = true
	options_menu.visible = false

func handle_connecting_signals() -> void:
	
	start_button.pressed.connect(_on_start_pressed)
	options_button.pressed.connect(_on_options_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	options_menu.exit_options_menu.connect(on_exit_options_menu)

func _on_multiplayerbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_button_mouse_entered() -> void:
	AudioManager.play_sound_effect(SoundEffect.SOUND_EFFECT_TYPE.UI_BUTTON_HOVER)
