class_name Disc
extends AnimatableBody2D

@export var speed: float = 100

@onready var visible_notifiers: Node2D = $VisibleNotifiers

var target_position: Vector2
var _direction: Vector2
var _exit_count: int


func _ready() -> void:
	_direction = (target_position - global_position).normalized()

	for child in visible_notifiers.get_children():
		var visible_notifier = child as VisibleOnScreenNotifier2D
		visible_notifier.screen_exited.connect(_on_screen_exited)


func _physics_process(delta: float) -> void:
	global_position += _direction * speed * delta


func _on_screen_exited() -> void:
	_exit_count += 1
	if _exit_count >= 3:
		queue_free()
