extends Control

@export var video_player: VideoStreamPlayer
@export var skip_label: Label
@export var loading_label: Label
@export var wait_video: float

var MAIN_MENU_SCENE_PATH = "scenes/mainMenu.tscn"

func _ready() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
  skip_label.visible = false
  video_player.play()
  ResourceLoader.load_threaded_request(MAIN_MENU_SCENE_PATH)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  var pos = video_player.stream_position

  if pos >= wait_video and skip_label.visible == false:
    skip_label.visible = true

  var progress = []
  ResourceLoader.load_threaded_get_status(MAIN_MENU_SCENE_PATH, progress)
  var percent = progress[0] * 100

  loading_label.text = "Loading scene... (" + str(percent) + "%)"

  if percent == 100:
    loading_label.visible = false

func _on_button_pressed() -> void:
  var pos = video_player.stream_position

  if pos >= wait_video:
    _on_video_stream_player_finished()

func _on_video_stream_player_finished() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(MAIN_MENU_SCENE_PATH))
