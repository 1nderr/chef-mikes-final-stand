class_name ShakingComponent
extends Node

var target: Node2D
var offset: Vector2 = Vector2.ZERO
var shake_intensity: float = 0.0
var active_shake_time: float = 0.0
var shake_decay: float = 5.0
var shake_time: float = 0.0
var shake_time_speed: float = 20.0
var only_shake_x: bool = false
var noise: FastNoiseLite = FastNoiseLite.new()


func _ready() -> void:
	target = get_parent()


func _physics_process(delta: float) -> void:
	if active_shake_time <= 0:
		offset = Vector2(
			lerpf(offset.x, 0.0, 10.5 * delta),
			lerpf(offset.y, 0.0, 10.5 * delta)
		)
	else:
		shake_time += delta * shake_time_speed
		active_shake_time -= delta
		offset = Vector2(
			noise.get_noise_2d(shake_time, 0) * shake_intensity,
			noise.get_noise_2d(0, shake_time) * shake_intensity
		)
		shake_intensity = maxf(shake_intensity - shake_decay * delta, 0.0)

	_set_offset()


func shake(intensity: int, time: float, p_only_shake_x: bool = false) -> void:
	noise.seed = randi()
	noise.frequency = 2.0
	shake_intensity = intensity
	active_shake_time = time
	shake_time = 0.0
	only_shake_x = p_only_shake_x
	shake_decay = intensity / time


func _set_offset() -> void:
	if target is Camera2D:
		target.offset = Vector2(offset.x, 0.0) if only_shake_x else offset
	elif target is Sprite2D:
		target.offset = Vector2(offset.x, 0.0) if only_shake_x else offset
