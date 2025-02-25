extends Node2D

@onready var loading_label: Label = $Control/LoadingLabel

var started: bool = false
var WORLD_SCENE_PATH = "scenes/world.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  ResourceLoader.load_threaded_request("scenes/world.tscn")

func _process(_delta: float) -> void:
  var progress = []
  ResourceLoader.load_threaded_get_status(WORLD_SCENE_PATH, progress)
  
  loading_label.text = "Loading... (" + str(int(progress[0] * 100)) + "%)"

  if progress[0] == 1:
    get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(WORLD_SCENE_PATH))
