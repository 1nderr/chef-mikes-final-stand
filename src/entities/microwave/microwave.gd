class_name Microwave
extends Area2D

enum Item { DISC, BOMB, SLOW }

@export var double_time: float = 1
@export var initial_delay: float = 10.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var ding: AudioStreamPlayer2D = $DingSound
@onready var close: AudioStreamPlayer2D = $CloseSound

var _item: Item
var is_hovered: bool = false
var _stopped = false


func _ready() -> void:
	sprite.play("off")
	timer.timeout.connect(_on_timer_timeout)
	SignalBus.microwave_start.connect(_on_microwave_start)
	SignalBus.player_died.connect(_on_player_died)
	# Kick off an opening cook with no choice; the first pick opens when it finishes.
	_start_initial_cook.call_deferred()


func _start_initial_cook() -> void:
	SignalBus.microwave_start.emit(Item.DISC, initial_delay)


func _process(_delta: float) -> void:
	if _stopped:
		return
	if sprite.animation == "on" and timer.time_left <= double_time:
		sprite.play("flash")
	if sprite.animation == "flash" and timer.time_left <= double_time and Input.is_action_just_pressed("open"):
		SignalBus.healed.emit()
		timer.stop()
		sprite.play("off")
		SignalBus.microwave_done.emit(_item)


func _on_microwave_start(item: Item, wait_time: float) -> void:
	sprite.play("on")
	close.play()
	_item = item
	timer.wait_time = wait_time + double_time
	timer.start()


func _on_player_died() -> void:
	_stopped = true


func _on_timer_timeout() -> void:
	ding.play()
	if _stopped:
		return
	sprite.play("off")
	SignalBus.microwave_done.emit(_item)
