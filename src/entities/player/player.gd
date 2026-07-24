class_name Player
extends Node2D

@export var bullet_scene: PackedScene
@export var bomb_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent

var _can_shoot = true
var _has_bomb = false
var _has_big_bomb = false
var _passed_skill_check = false


func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	SignalBus.microwave_done.connect(_on_microwave_done)
	GameManager.player = self


func _process(_delta: float) -> void:
	if _can_shoot and Input.is_action_pressed("shoot"):
		shoot()


func _unhandled_input(event: InputEvent) -> void:
	if (_has_bomb or _has_big_bomb) and event.is_action_pressed("bomb"):
		throw_bomb()


func shoot() -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.target_position = get_global_mouse_position()
	get_tree().current_scene.add_child(bullet)

	cooldown_timer.start()
	_can_shoot = false


func throw_bomb() -> void:
	var bomb = bomb_scene.instantiate() as Bomb
	bomb.global_position = get_global_mouse_position()

	if _has_big_bomb:
		bomb.double()

	get_tree().current_scene.add_child(bomb)

	_has_bomb = false
	_has_big_bomb = false


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _on_hurt(hitbox: Hitbox) -> void:
	health_component.take_damage(hitbox.damage)


func _on_died() -> void:
	SignalBus.player_died.emit()
	queue_free()


func _on_microwave_done(item: Microwave.Item) -> void:
	_has_bomb = false
	_has_big_bomb = false

	if item == Microwave.Item.HEALTH and _passed_skill_check:
		health_component.heal(2)
	elif item == Microwave.Item.HEALTH:
		health_component.heal(1)
	elif item == Microwave.Item.BOMB and _passed_skill_check:
		_has_big_bomb = true
	elif item == Microwave.Item.BOMB:
		_has_bomb = true
	elif item == Microwave.Item.SLOW and _passed_skill_check:
		SignalBus.slow_applied.emit(0)
	elif item == Microwave.Item.SLOW:
		SignalBus.slow_applied.emit(0.5)
