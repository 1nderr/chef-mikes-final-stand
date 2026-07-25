class_name IcePanel
extends ColorRect

@onready var sprite_flash: SpriteFlash = $SpriteFlash


func _ready() -> void:
	modulate.a = 0.0
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	SignalBus.slow_applied.connect(_on_slow_applied)


func _on_slow_applied(_time_scale: float) -> void:
	sprite_flash.flash()
