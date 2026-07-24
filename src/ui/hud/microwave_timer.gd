class_name MicrowaveTimer
extends Control

@export var green_label_settings: LabelSettings
@export var white_label_settings: LabelSettings

@onready var timer: Timer = $Timer
@onready var label: Label = $Label

var _is_hovered: bool = false
var _is_done: bool = false


func _ready() -> void:
	SignalBus.microwave_start.connect(_on_microwave_start)
	SignalBus.microwave_done.connect(_on_microwave_done)
	#SignalBus.microwave_mouse_entered.connect(_on_microwave_mouse_entered)
	#SignalBus.microwave_mouse_exited.connect(_on_microwave_mouse_exited)
	timer.timeout.connect(_on_timer_timeout)


func _process(_delta: float) -> void:
	if not timer.is_stopped():
		label.text = "00:%02d" % int(ceil(timer.time_left))

	visible = not _is_done


func _on_timer_timeout() -> void:
	label.text = "00:00"
	label.label_settings = white_label_settings


func _on_microwave_mouse_entered() -> void:
	_is_hovered = true


func _on_microwave_mouse_exited() -> void:
	_is_hovered = false


func _on_microwave_start(_item: Microwave.Item, wait_time: float) -> void:
	label.label_settings = green_label_settings
	timer.wait_time = wait_time
	timer.start()
	_is_done = false


func _on_microwave_done(_item: Microwave.Item) -> void:
	_is_done = true
