class_name Hurtbox
extends Area2D

signal hurt(hitbox: Hitbox)

var is_invincible: bool = false


func _init() -> void:
	monitoring = false
	monitorable = true


func set_active(enabled: bool) -> void:
	set_deferred("monitorable", enabled)


func take_hit(hitbox: Hitbox) -> void:
	if is_invincible:
		return

	hurt.emit(hitbox)
