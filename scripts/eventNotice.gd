extends RichTextLabel
class_name EventNotice

@export var animation_player : AnimationPlayer
@export var event_description : RichTextLabel

func _ready() -> void:
	EventBus.event_started.connect(on_event_start)

func on_event_start(event : Event):
	animation_player.play("display_event_notice")
	event_description.text = str("[center]", event.description)
	text = str(event.bbcode_prefix, event.name.capitalize())
	pass
