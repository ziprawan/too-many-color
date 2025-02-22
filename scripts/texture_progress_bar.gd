extends TextureProgressBar

@export var max_score: int = 100  # Nilai maksimum score
var current_score: int = 0       # Nilai score saat ini

func _ready():
	max_value = max_score
	value = current_score
	update_score_label()

func update_score(new_score: int):
	current_score = new_score
	value = current_score
	update_score_label()

func update_score_label():
	$ScoreLabel1.text = str(current_score)
