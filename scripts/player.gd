extends CharacterBody2D
class_name Player

@onready var sprite: Sprite2D = $Sprite

@export var speed = 700.0
@export var color := Color(1, 1, 1)
@export var player_id: int

var direction: Vector2
var score: float

func _ready() -> void:
  sprite.material = sprite.material.duplicate()

func _process(_delta):
  # Movement
  direction.x = Input.get_axis("left%s" % [player_id], "right%s" % [player_id])
  if direction:
    velocity = direction * speed
  else:
    velocity = velocity.move_toward(Vector2.ZERO, speed)
  move_and_slide()
  # Color Handling
  sprite.material.set_shader_parameter("ColorParameter", color)

func _on_collection_area_entered(area: Area2D) -> void:
  if area.is_in_group("droplet"):
    var droplet = area.get_parent()
    var droplet_color: Color = droplet.color

    print("Droplet color", droplet_color)

    # Set color alpha
    color.a = 0.8
    droplet_color.a = 0.2

    # Blend and calculate the player's score
    color = color.blend(droplet_color)
    print("Score?:", Utils.get_deltaE(color, Globals.target_color) ** 2.8)
    print("Target color", Globals.target_color, "Current color", color)
    Globals.player_scores[player_id] = 1000 - (Utils.get_deltaE(color, Globals.target_color) ** 2.8)
    Globals.player_colors[player_id] = color

    # Free the object
    droplet.queue_free()
