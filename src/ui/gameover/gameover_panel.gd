extends Control

@onready var label: Label = $Label
@onready var restart_button: TextureButton = $RestartButton
@onready var next_button: TextureButton = $NextButton


func _ready() -> void:
	visible = false
	SignalBus.gameover.connect(_on_gameover)
	SignalBus.player_died.connect(_on_player_died)


func _on_gameover() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true
	label.text = "you win!"
	next_button.visible = true
	restart_button.visible = false


func _on_player_died() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true
	label.text = "game over"
	restart_button.visible = true
	next_button.visible = false
