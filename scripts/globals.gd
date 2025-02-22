extends Node

var player_scores = [0.0, 0.0]
var player_colors = [Color(1, 1, 1), Color(1, 1, 1)]
var target_color: Color = Color.from_hsv(randf_range(0, 1), randf_range(0, 0.48), randf_range(0.65, 1), 1)
