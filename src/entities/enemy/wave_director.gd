class_name WaveDirector
extends Node


var enemy_scene: PackedScene
var spawn_root: Node
var spawn_points: Array[Vector2] = []
var microwave: Microwave

var first_wave_delay: float = 6.0
var wave_interval: float = 11.0
var telegraph_time: float = 4.0
var min_remaining_for_wave: int = 18
var no_wave_fraction: float = 1.0 / 3.0
var flash_guard: float = 3.0
var recheck_delay: float = 0.75

const FREEZE_DURATION: float = 5.0

var _pending_wave: String = ""
var _cadence_timer: Timer
var _telegraph_timer: Timer

var _time_scale: float = 1.0
var _slow_timer: Timer


func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.gameover.connect(_on_stopped)
	SignalBus.slow_applied.connect(_on_slow_applied)

	_cadence_timer = Timer.new()
	_cadence_timer.one_shot = true
	add_child(_cadence_timer)
	_cadence_timer.timeout.connect(_on_cadence_timeout)

	_telegraph_timer = Timer.new()
	_telegraph_timer.one_shot = true
	add_child(_telegraph_timer)
	_telegraph_timer.timeout.connect(_on_telegraph_timeout)

	_slow_timer = Timer.new()
	_slow_timer.one_shot = true
	add_child(_slow_timer)
	_slow_timer.timeout.connect(_on_slow_timer_timeout)

	_cadence_timer.start(first_wave_delay)


func _on_slow_applied(time_scale: float) -> void:
	_time_scale = time_scale
	_slow_timer.start(FREEZE_DURATION)


func _on_slow_timer_timeout() -> void:
	_time_scale = 1.0


func _on_cadence_timeout() -> void:
	if GameManager.enemies_remaining <= min_remaining_for_wave:
		return

	if GameManager.enemies_remaining > GameManager.enemies_total * (1.0 - no_wave_fraction):
		_cadence_timer.start(recheck_delay)
		return

	if microwave == null or microwave.time_until_flash() < flash_guard:
		_cadence_timer.start(recheck_delay)
		return

	if GameManager.discs <= 0 and GameManager.bombs <= 0 and GameManager.slows <= 0:
		_cadence_timer.start(recheck_delay)
		return

	_pending_wave = _decide_wave()
	SignalBus.wave_incoming.emit(_pending_wave)
	_telegraph_timer.start(telegraph_time)


func _decide_wave() -> String:
	var has_tank_counter := GameManager.discs > 0
	var has_rush_counter := GameManager.bombs > 0

	if has_tank_counter and not has_rush_counter:
		return "TANKS"
	if has_rush_counter and not has_tank_counter:
		return "RUSH"

	return _coin()


func _coin() -> String:
	return "TANKS" if randf() < 0.5 else "RUSH"


func _on_telegraph_timeout() -> void:
	_spawn_wave(_pending_wave)
	_cadence_timer.start(wave_interval)


func _spawn_wave(wave_name: String) -> void:
	if spawn_points.is_empty():
		return

	if wave_name == "TANKS":
		_spawn_column([["red", 3], ["red", 3], ["red", 3], ["purple", 2]])
	else:
		_spawn_scatter([["white", 1], ["white", 1], ["white", 1], ["white", 1], ["white", 1],
			["white", 1], ["white", 1], ["white", 1], ["white", 1]])


func _spawn_column(configs: Array) -> void:
	var origin: Vector2 = spawn_points[randi() % spawn_points.size()]
	var dir := Vector2.DOWN
	var player := GameManager.player
	if is_instance_valid(player):
		dir = (origin - player.global_position).normalized()
	var perp := dir.orthogonal()

	var i: int = 0
	for cfg in configs:
		if GameManager.enemies_remaining - GameManager.enemies_spawned <= 0:
			break
		var pos: Vector2 = origin + dir * (i * 16.0) + perp * randf_range(-4.0, 4.0)
		_spawn_one(cfg[0], cfg[1], pos)
		i += 1


func _spawn_scatter(configs: Array) -> void:
	var points := _pick_points(3)
	var idx: int = 0
	for cfg in configs:
		if GameManager.enemies_remaining - GameManager.enemies_spawned <= 0:
			break
		var origin: Vector2 = points[idx % points.size()]
		idx += 1
		var pos: Vector2 = origin + Vector2(randf_range(-16.0, 16.0), randf_range(-16.0, 16.0))
		_spawn_one(cfg[0], cfg[1], pos)


func _spawn_one(color: String, hp: int, pos: Vector2) -> void:
	GameManager.enemies_spawned += 1
	var enemy := enemy_scene.instantiate() as Enemy
	enemy.color = color
	enemy.hp = hp
	enemy.global_position = pos
	spawn_root.add_child(enemy)
	if not _slow_timer.is_stopped():
		enemy.apply_slow.call_deferred(_time_scale, _slow_timer.time_left)


func _pick_points(n: int) -> Array[Vector2]:
	var pool := spawn_points.duplicate()
	pool.shuffle()
	var count: int = min(n, pool.size())
	return pool.slice(0, count)


func _on_player_died() -> void:
	_on_stopped()


func _on_stopped() -> void:
	_cadence_timer.stop()
	_telegraph_timer.stop()
