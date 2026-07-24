class_name HealthBar
extends HBoxContainer

func _ready() -> void:
	SignalBus.health_updated.connect(_on_health_updated)


func _on_health_updated(health: int) -> void:
	if get_child_count() == 0:
		return
	var children = get_children()
	for i in range(GameManager.player.health_component.max_hp):
		if i + 1 <= health:
			children[i].visible = true
		else:
			children[i].visible = false
