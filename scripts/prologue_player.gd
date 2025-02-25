extends Control

@export var video_player: VideoStreamPlayer
@export var skip_label: Label
@export var loading_label: Label
@export var wait_video: float
@export var cursor_visibility_time: float

var MAIN_MENU_SCENE_PATH = "scenes/mainMenu.tscn"
var ignore_keys = [KEY_ALT, KEY_SHIFT, KEY_CTRL, KEY_META, KEY_PRINT]
var cursor_last_time_visible: float = -1

func _ready() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
  skip_label.visible = false
  video_player.play()
  ResourceLoader.load_threaded_request(MAIN_MENU_SCENE_PATH)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if cursor_last_time_visible != -1:
    # Cursor visibility changed
    var now = Time.get_unix_time_from_system()
  
    if now - cursor_last_time_visible <= cursor_visibility_time:
      Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    else:
      Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

  var pos = video_player.stream_position

  if pos >= wait_video and skip_label.visible == false:
    skip_label.visible = true

  var progress = []
  ResourceLoader.load_threaded_get_status(MAIN_MENU_SCENE_PATH, progress)
  var percent = progress[0] * 100

  loading_label.text = "Loading scene... (" + str(int(percent)) + "%)"

  if percent == 100:
    loading_label.visible = false

func skip_video():
  var pos = video_player.stream_position

  if pos >= wait_video:
    _on_video_stream_player_finished()

func _input(event: InputEvent) -> void:
  if event is InputEventKey:
    if event.pressed:
      var skip = false
      
      if not ignore_keys.has(event.keycode):
        if not event.get_modifiers_mask() > 0:
          skip = true

      if skip:
        skip_video()
  elif event is InputEventMouseButton:
    if event.pressed:
      skip_video()
  elif event is InputEventMouseMotion:
    cursor_last_time_visible = Time.get_unix_time_from_system()

func _on_video_stream_player_finished() -> void:
  Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
  get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(MAIN_MENU_SCENE_PATH))
