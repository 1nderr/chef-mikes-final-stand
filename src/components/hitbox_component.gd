class_name Hitbox
extends Area2D

signal hit(hurtbox: Hurtbox)

@export var damage: int = 1


func _init() -> void:
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_entered)


func set_active(enabled: bool) -> void:
	set_deferred("monitoring", enabled)


func _on_area_entered(area: Area2D) -> void:
	if not area is Hurtbox:
		return

	var hurtbox := area as Hurtbox
	if hurtbox.is_invincible:
		return

	hurtbox.take_hit(self)
	hit.emit(hurtbox)
