extends CharacterBody2D

@export var speed: float = 300.0  # Kecepatan gerakan karakter
@export var gravity: float = 500.0  # Gravitasi karakter

func _physics_process(_delta):
    var velocity = self.velocity  # Ambil kecepatan saat ini

    # Input untuk gerakan karakter
    if Input.is_action_pressed("ui_left"):  # Tombol A atau Panah Kiri
        velocity.x = -speed
    if Input.is_action_pressed("ui_right"):  # Tombol D atau Panah Kanan
        velocity.x = speed
    if not Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
        velocity.x = 0

    # Terapkan gravitasi
    velocity.y += gravity * _delta

    # Terapkan kecepatan ke karakter
    self.velocity = velocity
    move_and_slide()