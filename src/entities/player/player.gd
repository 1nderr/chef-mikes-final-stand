class_name Player
extends Node2D

@export var bullet_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent

var _can_shoot = true
var _has_bomb = false


func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	SignalBus.microwave_done.connect(_on_microwave_done)
	GameManager.player = self


func _process(_delta: float) -> void:
	if _can_shoot and Input.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.global_position = global_position
	bullet.target_position = get_global_mouse_position()
	get_tree().current_scene.add_child(bullet)

	cooldown_timer.start()
	_can_shoot = false


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _on_hurt(hitbox: Hitbox) -> void:
	health_component.take_damage(hitbox.damage)


func _on_died() -> void:
	queue_free()


func _on_microwave_done(item: Microwave.Item) -> void:
	if item == Microwave.Item.HEALTH:
		health_component.heal(1)
	elif item == Microwave.Item.BOMB:
		_has_bomb = true
	elif item == Microwave.Item.SLOW:
		SignalBus.slow_applied.emit(0.5)
