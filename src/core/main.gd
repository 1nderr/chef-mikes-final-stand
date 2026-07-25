extends Node2D

@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D


func _ready() -> void:
	GameManager.reset()
	SignalBus.gameover.connect(_on_gameover)
	SignalBus.player_died.connect(_on_player_died)


func _on_gameover() -> void:
	music.stop()


func _on_player_died() -> void:
	music.stop()
