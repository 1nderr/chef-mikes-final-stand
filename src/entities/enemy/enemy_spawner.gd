class_name EnemySpawner
extends Marker2D

@export var min_spawn_time: float = 2
@export var max_spawn_time: float = 5
@export var enemy_scene: PackedScene

# Difficulty ramp: interval shrinks and tough enemies grow as the order is filled.
# Reds are kept rare here on purpose — they're the telegraphed TANK-wave threat
# (where a disc can line them up); the ramp carries fair white/purple pressure.
@export var late_interval_mult: float = 0.4
@export var red_chance_early: float = 0.0
@export var red_chance_late: float = 0.08
@export var purple_chance_early: float = 0.12
@export var purple_chance_late: float = 0.33

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
	var progress := _progress()
	var slow_factor: float = (1.0 / _time_scale) if _time_scale > 0.0 else 1.0
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time) * lerp(1.0, late_interval_mult, progress) * slow_factor
	spawn_timer.start()

	if GameManager.enemies_remaining - GameManager.enemies_spawned <= 0:
		return

	GameManager.enemies_spawned += 1

	var enemy = enemy_scene.instantiate() as Enemy

	enemy.global_position = global_position

	var roll := randf()
	var red_chance: float = lerp(red_chance_early, red_chance_late, progress)
	var purple_chance: float = lerp(purple_chance_early, purple_chance_late, progress)
	if roll < red_chance:
		enemy.color = "red"
		enemy.hp = 3
	elif roll < red_chance + purple_chance:
		enemy.color = "purple"
		enemy.hp = 2

	owner.add_child(enemy)
	if slow_timer.is_stopped():
		return
	enemy.apply_slow.call_deferred(_time_scale, slow_timer.time_left)


func _progress() -> float:
	return clamp(1.0 - float(GameManager.enemies_remaining) / float(GameManager.ENEMIES_TOTAL), 0.0, 1.0)


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
	if time_scale <= 0:
		spawn_timer.stop()
	elif not spawn_timer.is_stopped():
		# Stretch the in-flight interval so spawning also slows during the freeze.
		spawn_timer.start(spawn_timer.time_left / time_scale)
