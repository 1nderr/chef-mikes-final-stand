class_name MicrowavePanel
extends Control

func _ready() -> void:
	get_tree().paused = true
	SignalBus.microwave_done.connect(_on_microwave_done)


func _on_microwave_done(_item: Microwave.Item) -> void:
	get_tree().paused = true
	visible = true
