class_name Microwave
extends Node2D

enum Item { HEALTH, BOMB, SLOW }

@onready var timer: Timer = $Timer

var _item: Item


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	SignalBus.microwave_start.connect(_on_microwave_start)


func _on_microwave_start(item: Item, wait_time: float) -> void:
	_item = item
	timer.wait_time = wait_time
	timer.start()


func _on_timer_timeout() -> void:
	SignalBus.microwave_done.emit(_item)
