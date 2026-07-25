extends Node2D

const ENEMY_SCENE := preload("res://src/entities/enemy/enemy.tscn")
const WaveDirectorScript := preload("res://src/entities/enemy/wave_director.gd")
const WaveWarningScript := preload("res://src/ui/hud/wave_warning.gd")

@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var spawners: Node2D = $Spawners
@onready var hud: CanvasLayer = $HUD


func _ready() -> void:
	# reload_current_scene() doesn't clear a leftover pause from the end screen.
	get_tree().paused = false
	GameManager.reset()
	SignalBus.gameover.connect(_on_gameover)
	SignalBus.player_died.connect(_on_player_died)
	_setup_waves()


func _setup_waves() -> void:
	var director := WaveDirectorScript.new()
	director.enemy_scene = ENEMY_SCENE
	director.spawn_root = self
	for child in spawners.get_children():
		director.spawn_points.append((child as Node2D).global_position)
	add_child(director)

	hud.add_child(WaveWarningScript.new())


func _on_gameover() -> void:
	music.stop()


func _on_player_died() -> void:
	music.stop()
