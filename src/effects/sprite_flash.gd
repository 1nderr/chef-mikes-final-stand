class_name SpriteFlash
extends Node

@export var target: CanvasItem
@export var flash_color: Color = Color.RED
@export var flash_duration: float = 0.25
@export var is_overlay: bool = false


func flash() -> void:
	var tween = create_tween()

	if is_overlay:
		target.modulate = Color(flash_color, 0.0)
		tween.tween_property(target, "modulate:a", 0.6, 0.05) 
		tween.tween_property(target, "modulate:a", 0.0, flash_duration)
	else:
		target.modulate = flash_color
		tween.tween_property(target, "modulate", Color.WHITE, flash_duration)
