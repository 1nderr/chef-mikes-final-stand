extends Label

func _process(_delta: float) -> void:
	text = str(GameManager.enemies_remaining)
