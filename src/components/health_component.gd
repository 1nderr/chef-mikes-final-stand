class_name HealthComponent
extends Node

signal died

@export var max_hp: int = 1

var _hp: int = 0


func _ready() -> void:
	_hp = max_hp


func take_damage(amount: int) -> void:
	if _hp == 0:
		return

	_hp = max(0, _hp - amount)
	if _hp == 0:
		died.emit()


func heal(amount: int) -> void:
	if _hp == max_hp:
		return

	_hp = min(max_hp, _hp + amount)


func get_hp() -> int:
	return _hp


func is_full_hp() -> bool:
	return _hp == max_hp
