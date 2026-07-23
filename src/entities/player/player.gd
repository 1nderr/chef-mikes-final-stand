class_name Player
extends Node2D

@export var bullet_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer

var _can_shoot = true


func _ready() -> void:
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)


func _process(_delta: float) -> void:
	if _can_shoot and Input.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.target_position = get_global_mouse_position()
	get_tree().current_scene.add_child(bullet)

	cooldown_timer.start()
	_can_shoot = false


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true
