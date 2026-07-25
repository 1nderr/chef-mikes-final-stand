class_name EnemySpawner
extends Marker2D

@export var min_spawn_time: float = 1
@export var max_spawn_time: float = 5
@export var enemy_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer
@onready var slow_timer: Timer = $SlowTimer

var _time_scale: float = 1.0


func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.slow_applied.connect(_on_slow_applied)

	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()

	slow_timer.timeout.connect(_on_slow_timer_timeout)


func _on_spawn_timer_timeout() -> void:
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time)
	spawn_timer.start()

	if GameManager.enemies_remaining - GameManager.enemies_spawned <= 0:
		return

	GameManager.enemies_spawned += 1

	var enemy = enemy_scene.instantiate() as Enemy

	enemy.global_position = global_position

	var i := randi_range(1, 10)
	if i == 1:
		enemy.color = "red"
		enemy.hp = 3
	elif i == 2 or i == 3:
		enemy.color = "purple"
		enemy.hp = 2

	owner.add_child(enemy)
	if slow_timer.is_stopped():
		return
	enemy.apply_slow.call_deferred(_time_scale, slow_timer.time_left)


func _on_player_died() -> void:
	queue_free()


func _on_slow_timer_timeout() -> void:
	if spawn_timer.is_stopped():
		spawn_timer.start()
	SignalBus.slow_done.emit()
	_time_scale = 1.0


func _on_slow_applied(time_scale: float) -> void:
	_time_scale = time_scale
	slow_timer.start()
	if time_scale == 0:
		spawn_timer.stop()
