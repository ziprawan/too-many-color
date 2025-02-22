extends Node2D

@onready var player1_score_label: Label = $PlayerLabel1/ScoreLabel
@onready var player2_score_label: Label = $PlayerLabel2/ScoreLabel
@onready var player1_score_bar: TextureProgressBar = $ScoreBar1
@onready var player2_score_bar: TextureProgressBar = $ScoreBar2

var current_score: float = 0.0

var game_manager: GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  game_manager = get_node("/root/World")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  # Tally score
  player1_score_label.text = str(game_manager.player_set_tally[0])
  player2_score_label.text = str(game_manager.player_set_tally[1])

  current_score = game_manager.player_scores[0] / 10
  player1_score_bar.value = current_score

  current_score = game_manager.player_scores[1] / 10
  player2_score_bar.value = current_score
