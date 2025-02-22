class_name MainMenu
extends Control

@onready var options_button = $VBoxContainer/OptionsButton as Button
@onready var options_menu = $OptionsMenu as OptionsMenu
@onready var vbox_container = $VBoxContainer as VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  handle_connecting_signals()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

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
  options_button.button_down.connect(_on_options_pressed)
  options_menu.exit_options_menu.connect(on_exit_options_menu)
