class_name WaveDirector
extends Node

# Injects telegraphed enemy bursts on top of the baseline spawner trickle.
# Alternates TANKS / RUSH on a learnable rhythm so cooking the counter can be planned.

# Set by main.gd before add_child():
var enemy_scene: PackedScene
var spawn_root: Node
var spawn_points: Array[Vector2] = []

# Tuning knobs.
var first_wave_delay: float = 12.0
var wave_interval: float = 20.0
var telegraph_time: float = 4.0
# Stop layering waves once the endgame (the ramp's own crescendo) takes over,
# so a telegraphed wave never fizzles against the kill-budget gate.
var min_remaining_for_wave: int = 18

var _wave_index: int = 0
var _pending_wave: String = ""
var _cadence_timer: Timer
var _telegraph_timer: Timer


func _ready() -> void:
	SignalBus.player_died.connect(_on_player_died)
	SignalBus.gameover.connect(_on_stopped)

	_cadence_timer = Timer.new()
	_cadence_timer.one_shot = true
	add_child(_cadence_timer)
	_cadence_timer.timeout.connect(_on_cadence_timeout)

	_telegraph_timer = Timer.new()
	_telegraph_timer.one_shot = true
	add_child(_telegraph_timer)
	_telegraph_timer.timeout.connect(_on_telegraph_timeout)

	_cadence_timer.start(first_wave_delay)


func _on_cadence_timeout() -> void:
	if GameManager.enemies_remaining <= min_remaining_for_wave:
		return  # endgame crescendo handles the finish; no more waves

	_pending_wave = "TANKS" if _wave_index % 2 == 0 else "RUSH"
	_wave_index += 1
	SignalBus.wave_incoming.emit(_pending_wave)
	_telegraph_timer.start(telegraph_time)


func _on_telegraph_timeout() -> void:
	_spawn_wave(_pending_wave)
	_cadence_timer.start(wave_interval)


func _spawn_wave(wave_name: String) -> void:
	if spawn_points.is_empty():
		return

	if wave_name == "TANKS":
		# Single-file column receding away from the player, so a disc pierces the line.
		_spawn_column([["red", 3], ["red", 3], ["red", 3], ["purple", 2]])
	else:
		# Scattered swarm; they converge on the player where a bomb's AoE catches them.
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
		# enemies_spawned is incremented inside _spawn_one


func _spawn_one(color: String, hp: int, pos: Vector2) -> void:
	GameManager.enemies_spawned += 1
	var enemy := enemy_scene.instantiate() as Enemy
	enemy.color = color
	enemy.hp = hp
	enemy.global_position = pos
	spawn_root.add_child(enemy)


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
