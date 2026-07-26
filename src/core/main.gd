extends Node2D

const ENEMY_SCENE := preload("res://src/entities/enemy/enemy.tscn")
const WaveDirectorScript := preload("res://src/entities/enemy/wave_director.gd")
const WaveWarningScript := preload("res://src/ui/hud/wave_warning.gd")

@onready var music: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var spawners: Node2D = $Spawners
@onready var hud: CanvasLayer = $HUD
@onready var microwave: Microwave = $EntitiesRoot/Microwave


func _ready() -> void:
	get_tree().paused = false
	GameManager.reset()
	SignalBus.gameover.connect(_on_gameover)
	SignalBus.player_died.connect(_on_player_died)
	_setup_waves()


func _setup_waves() -> void:
	var director := WaveDirectorScript.new()
	director.enemy_scene = ENEMY_SCENE
	director.spawn_root = self
	director.microwave = microwave
	for child in spawners.get_children():
		director.spawn_points.append((child as Node2D).global_position)
	add_child(director)

	hud.add_child(WaveWarningScript.new())


func _on_gameover() -> void:
	music.stop()
	GameManager.register_win()


func _on_player_died() -> void:
	music.stop()
