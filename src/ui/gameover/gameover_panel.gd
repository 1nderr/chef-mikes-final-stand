extends Control

@onready var label: Label = $Label


func _ready() -> void:
	visible = false
	SignalBus.gameover.connect(_on_gameover)
	SignalBus.player_died.connect(_on_player_died)


func _on_gameover() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true
	label.text = "winner"


func _on_player_died() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true
	label.text = "loser"
