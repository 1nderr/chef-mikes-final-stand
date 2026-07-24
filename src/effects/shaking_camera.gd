class_name ShakingCamera
extends Camera2D

var shaking_component: ShakingComponent


func _ready() -> void:
	shaking_component = $ShakingComponent
	GameManager.camera = self


func screen_shake(intensity: int, time: float) -> void:
	shaking_component.shake(intensity, time)
