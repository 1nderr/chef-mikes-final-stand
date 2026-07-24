class_name Enemy
extends CharacterBody2D

@export var speed = 50.0
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent
@onready var slow_timer: Timer = $SlowTimer

var _time_scale = 1.0


func _ready() -> void:
	hitbox.hit.connect(_on_hit)
	hurtbox.hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	slow_timer.timeout.connect(_on_slow_timer_timeout)
	SignalBus.slow_applied.connect(_on_slow_applied)


func _physics_process(_delta: float) -> void:
	var player = GameManager.player
	if not is_instance_valid(player):
		return

	var direction: Vector2 = (player.global_position - global_position).normalized()
	velocity = direction * speed * _time_scale

	move_and_slide()


func _on_hurt(_hitbox: Hitbox) -> void:
	health_component.take_damage(_hitbox.damage)


func _on_died() -> void:
	queue_free()


func _on_hit(_hurtbox: Hurtbox) -> void:
	queue_free()


func _on_slow_timer_timeout() -> void:
	_time_scale = 1.0


func _on_slow_applied(time_scale: float) -> void:
	_time_scale = time_scale
	slow_timer.start()
