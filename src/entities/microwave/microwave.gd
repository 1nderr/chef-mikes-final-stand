class_name Microwave
extends Area2D

enum Item { DISC, BOMB, SLOW }

@export var double_time: float = 1.25
@export var initial_delay: float = 10.0
@export var hum_pitch_start: float = 1.0
@export var hum_pitch_end: float = 1.7
@export var heal_flash_hold: float = 0.5

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var ding: AudioStreamPlayer2D = $DingSound
@onready var close: AudioStreamPlayer2D = $CloseSound
@onready var hum: AudioStreamPlayer2D = $HumSound

var _item: Item
var is_hovered: bool = false
var _stopped = false
var _hum_tween: Tween
var _suppress_close := false


func _ready() -> void:
	sprite.play("off")
	timer.timeout.connect(_on_timer_timeout)
	SignalBus.microwave_start.connect(_on_microwave_start)
	SignalBus.player_died.connect(_on_player_died)
	_start_initial_cook.call_deferred()


func _start_initial_cook() -> void:
	_suppress_close = true
	SignalBus.microwave_start.emit(Item.DISC, initial_delay)


func cook_time_left() -> float:
	if timer.is_stopped():
		return -1.0
	return timer.time_left


func time_until_flash() -> float:
	var left := cook_time_left()
	if left < 0.0:
		return -1.0
	return left - double_time


func _process(_delta: float) -> void:
	if _stopped:
		return
	if sprite.animation == "on" and timer.time_left <= double_time:
		sprite.play("flash")
		_start_hum()
	if sprite.animation == "flash" and timer.time_left <= double_time and Input.is_action_just_pressed("open"):
		_grab()


func _grab() -> void:
	timer.stop()
	sprite.play("off")
	_stop_hum()
	SignalBus.healed.emit()
	await get_tree().create_timer(heal_flash_hold).timeout
	if _stopped:
		return
	SignalBus.microwave_done.emit(_item)


func _start_hum() -> void:
	hum.pitch_scale = hum_pitch_start
	hum.play()
	if _hum_tween:
		_hum_tween.kill()
	_hum_tween = create_tween()
	_hum_tween.tween_property(hum, "pitch_scale", hum_pitch_end, double_time)


func _stop_hum() -> void:
	if _hum_tween:
		_hum_tween.kill()
		_hum_tween = null
	hum.stop()


func _on_microwave_start(item: Item, wait_time: float) -> void:
	sprite.play("on")
	if _suppress_close:
		_suppress_close = false
	else:
		close.play()
	_item = item
	timer.wait_time = wait_time + double_time
	timer.start()


func _on_player_died() -> void:
	_stopped = true
	_stop_hum()


func _on_timer_timeout() -> void:
	_stop_hum()
	ding.play()
	if _stopped:
		return
	sprite.play("off")
	SignalBus.microwave_done.emit(_item)
