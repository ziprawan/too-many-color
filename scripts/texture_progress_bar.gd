extends TextureProgressBar

@export var max_score: int = 100 # Nilai maksimum score
var current_score: float = 0.0

func _ready():
	max_value = max_score
	value = current_score

func _process(_delta: float) -> void:
	current_score = Globals.player_scores[0] / 10
	value = current_score
