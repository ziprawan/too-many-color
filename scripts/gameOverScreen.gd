extends Control
class_name GameOverScreen

@export var winner_sprite : AnimatedSprite2D
@export var winner_player_text : RichTextLabel
@export var loser_sprite : AnimatedSprite2D
@export var loser_player_text : RichTextLabel
@export var animation_player : AnimationPlayer
var game_manager : GameManager

func _ready() -> void:
	visible = false
	if get_tree().current_scene is GameManager:
		game_manager = get_tree().current_scene
	EventBus.connect("game_over", on_game_over)

func on_game_over():
	visible = true
	loser_player_text.text = str("[center][shake rate=15 level=25]P", 2 - game_manager.winner_id)
	winner_player_text.text = str("[center][shake rate=15 level=25][rainbow freq=0.3 sat=0.5]P", game_manager.winner_id + 1)
	winner_sprite.play("win_%d"%game_manager.winner_id)

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouse:
		if event.button_mask == 1 and event.button_index == 1:
			get_tree().change_scene_to_file("res://scenes/mainMenu.tscn")
