extends Node2D

# Variabel untuk menyimpan waktu countdown
var time_left = 3

# Referensi ke Label (pastikan Anda sudah menambahkan Label ke scene dan memberinya nama "TeksCountdown")
@onready var countdown_label = $TeksCountdown

func _ready():
	# Mulai countdown
	start_countdown()

func start_countdown():
	# Loop selama waktu countdown belum habis
	while time_left > 0:
		# Update teks label
		countdown_label.text = " %d" % time_left
		
		# Tunggu 1 detik
		await get_tree().create_timer(1.0).timeout
		
		# Kurangi waktu
		time_left -= 1
	
	# Setelah countdown selesai, update teks menjadi "GO!"
	countdown_label.text = "GO!"
	# Kirim sinyal countdown_over
	EventBus.emit_signal("countdown_over")
	
	# Tunggu sebentar (misalnya 1 detik) sebelum menghilangkan teks "GO!"
	await get_tree().create_timer(1.0).timeout
	
	# Hilangkan teks "GO!" dengan mengosongkan teks pada Label
	countdown_label.text = ""
	
