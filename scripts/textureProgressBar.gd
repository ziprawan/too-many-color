extends TextureProgressBar

@export var max_score: int = 100 # Nilai maksimum score
var current_score: float = 0.0

var game_manager : GameManager

func _ready():
	game_manager = get_tree().current_scene
	max_value = max_score
	value = current_score

func _process(_delta: float) -> void:
	current_score = game_manager.player_scores[0] / 10
	value = current_score
