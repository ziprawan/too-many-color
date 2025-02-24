extends Node2D

var sound_effects_dict : Dictionary = {}
@export var sound_effects : Array[SoundEffect]


func _ready() -> void:
	for sound_effect in sound_effects:
		sound_effects_dict[sound_effect.type] = sound_effect
	pass

func play_sound_effect(type : SoundEffect.SOUND_EFFECT_TYPE):
	if sound_effects_dict.has(type):
		var sound_effect : SoundEffect = sound_effects_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			# Creates a new AudioPlayer2D
			var new_audio_player : AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_audio_player)
			new_audio_player.stream = sound_effect.audio
			new_audio_player.volume_db = sound_effect.volume
			new_audio_player.pitch_scale = sound_effect.pitch_scale
			new_audio_player.finished.connect(sound_effect.on_audio_finished)
			new_audio_player.finished.connect(new_audio_player.queue_free)
			new_audio_player.play()
		pass
