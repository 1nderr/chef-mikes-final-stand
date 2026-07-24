class_name EnemySpawner
extends Marker2D

@export var min_spawn_time: float = 1
@export var max_spawn_time: float = 5
@export var enemy_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)

	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()


func _on_spawn_timer_timeout() -> void:
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.start()

	var enemy = enemy_scene.instantiate() as Enemy

	enemy.global_position = global_position
	owner.add_child(enemy)


func _on_player_died() -> void:
	queue_free()
