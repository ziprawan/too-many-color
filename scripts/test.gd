extends Node2D

var score: int = 0

func _ready():
	# Menghubungkan signal atau memanggil fungsi untuk mengupdate score
	update_score(0)

func update_score(points: int):
	if score == 100:
		return 
	score += points
	$UIScene/ScoreBar1.update_score(score)

func _input(event):
	if event.is_action_pressed("ui_accept"):  # Contoh: tekan tombol "Accept" untuk menambah score
		update_score(10)
