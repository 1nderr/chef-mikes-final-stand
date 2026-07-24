class_name Microwave
extends Node2D

enum Item { HEALTH, BOMB, SLOW }

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var _item: Item


func _ready() -> void:
	sprite.play("off")
	timer.timeout.connect(_on_timer_timeout)
	SignalBus.microwave_start.connect(_on_microwave_start)


func _on_microwave_start(item: Item, wait_time: float) -> void:
	sprite.play("on")
	_item = item
	timer.wait_time = wait_time
	timer.start()


func _on_timer_timeout() -> void:
	sprite.play("off")
	SignalBus.microwave_done.emit(_item)
