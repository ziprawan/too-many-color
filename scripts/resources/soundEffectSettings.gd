extends Resource
class_name SoundEffect

enum SOUND_EFFECT_TYPE {
	UI_BUTTON_HOVER,
	UI_BUTTON_PRESS,
	PLAYER_FOOTSTEP,
	WATER_DROPLET,
}

@export_range(0, 10) var instance_limit : int = 3
@export var type : SOUND_EFFECT_TYPE

@export var audio: AudioStream
@export_range(-40, 20) var volume: float = 0
@export_range(0.0, 4.0,.01) var pitch_scale: float = 1.0
@export_range(0.0, 1.0, .01) var pitch_randomness : float = 0

var instance_count : int = 0 # How many instances are currently playing

func change_audio_count(amount : int):
	instance_count = max(0, instance_count + amount)

func has_open_limit() -> bool:
	return instance_count < instance_limit

func on_audio_finished():
	change_audio_count(-1)
