extends VBoxContainer
class_name Temp_ScoreDisplay

var game_manager : GameManager

@export var p1_score_label: RichTextLabel
@export var p2_score_label: RichTextLabel
@export var p1_set_score: RichTextLabel
@export var p2_set_score: RichTextLabel
@export var p1_set_tally : RichTextLabel
@export var p2_set_tally : RichTextLabel
@export var target_color_label: RichTextLabel

func _ready(): game_manager = get_tree().current_scene

func _process(_delta: float) -> void:
	p1_score_label.text = str("P1 : ", game_manager.player_scores[0], ", dE: ", game_manager.player_dE[0])
	p2_score_label.text = str("P2 : ", game_manager.player_scores[1], ", dE: ", game_manager.player_dE[1])
	target_color_label.text = str("Target : ", game_manager.current_target_color)
	p1_set_score.text = str("P1 Set Score : ", game_manager.player_set_scores[0])
	p2_set_score.text = str("P2 Set Score : ", game_manager.player_set_scores[1])
	p1_set_tally.text = str("P1 Set Tally : ", game_manager.player_set_tally[0])
	p2_set_tally.text = str("P2 Set Tally : ", game_manager.player_set_tally[1])
