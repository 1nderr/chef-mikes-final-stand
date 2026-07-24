class_name MicrowaveButton
extends Button

@export var item: Microwave.Item = Microwave.Item.HEALTH
@export var wait_time: float = 10


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	SignalBus.microwave_start.emit(item, wait_time)
	owner.visible = false
	get_tree().paused = false
