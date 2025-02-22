extends VBoxContainer
class_name Temp_ScoreDisplay

@export var p1_score_label: RichTextLabel
@export var p2_score_label: RichTextLabel
@export var p1_color_label: RichTextLabel
@export var p2_color_label: RichTextLabel
@export var target_color_label: RichTextLabel

func _process(_delta: float) -> void:
  p1_score_label.text = str("P1 : ", Globals.player_scores[0])
  p2_score_label.text = str("P2 : ", Globals.player_scores[1])
  target_color_label.text = str("Target : ", Globals.target_color)
  p1_color_label.text = str("Color1 : ", Globals.player_colors[0])
  p2_color_label.text = str("Color2 : ", Globals.player_colors[1])
