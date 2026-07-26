extends Control

@onready var label: Label = $Label
@onready var sub_label: Label = $SubLabel
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
	sub_label.visible = true
	_update_next_subtext.call_deferred()


func _on_player_died() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().paused = true
	visible = true
	label.text = "game over"
	restart_button.visible = true
	next_button.visible = false
	sub_label.visible = false


func _update_next_subtext() -> void:
	var next_total: int = GameManager.enemies_total
	var cleared: int = next_total - GameManager.WIN_INCREMENT
	sub_label.text = "Next: %d -> %d enemies" % [cleared, next_total]
