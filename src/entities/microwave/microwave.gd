class_name Microwave
extends Area2D

enum Item { DISC, BOMB, SLOW }

@export var double_time: float = 1

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var _item: Item
var is_hovered: bool = false


func _ready() -> void:
	sprite.play("off")
	timer.timeout.connect(_on_timer_timeout)
	SignalBus.microwave_start.connect(_on_microwave_start)


func _process(_delta: float) -> void:
	if sprite.animation == "on" and timer.time_left <= double_time:
		sprite.play("flash")
	if sprite.animation == "flash" and timer.time_left <= double_time and Input.is_action_just_pressed("open"):
		SignalBus.healed.emit()

	_check_mouse_hover()


func _check_mouse_hover() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var currently_hovered: bool = _is_point_inside(mouse_pos)

	if currently_hovered != is_hovered:
		is_hovered = currently_hovered
		if is_hovered:
			SignalBus.microwave_mouse_entered.emit()
		else:
			SignalBus.microwave_mouse_exited.emit()


func _is_point_inside(point: Vector2) -> bool:
	var transform_inv = global_transform.inverse()
	var local_point = transform_inv * point

	for child in get_children():
		if child is CollisionShape2D and child.shape:
			if child.shape.get_rect().has_point(local_point):
				return true
	return false


func _on_microwave_start(item: Item, wait_time: float) -> void:
	sprite.play("on")
	_item = item
	timer.wait_time = wait_time + double_time
	timer.start()


func _on_timer_timeout() -> void:
	sprite.play("off")
	SignalBus.microwave_done.emit(_item)
