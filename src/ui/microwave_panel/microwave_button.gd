class_name MicrowaveButton
extends TextureButton

@export var item: Microwave.Item = Microwave.Item.HEALTH
@export var wait_time: float = 10


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_pressed() -> void:
	SignalBus.microwave_start.emit(item, wait_time)
	owner.visible = false
	get_tree().paused = false


func _on_mouse_entered() -> void:
	self_modulate = Color(1.4, 1.4, 1.4, 1.0)


func _on_mouse_exited() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)
