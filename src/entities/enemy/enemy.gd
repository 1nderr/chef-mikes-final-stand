class_name Enemy
extends CharacterBody2D

@export var speed = 50.0
@export var smoke_scene: PackedScene
@export var slow_color: Color = Color(0.35686275, 0.43137255, 0.88235295, 1)

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Hitbox = $Hitbox
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent
@onready var slow_timer: Timer = $SlowTimer
@onready var sprite_flash: SpriteFlash = $SpriteFlash

const SLOW_RECOVER_TIME := 0.6

var _time_scale = 1.0
var _recover_tween: Tween
var color = "white"
var hp = 1


func _ready() -> void:
	hitbox.hit.connect(_on_hit)
	hurtbox.hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	slow_timer.timeout.connect(_on_slow_timer_timeout)
	SignalBus.slow_applied.connect(_on_slow_applied)
	sprite.play(color)
	health_component.max_hp = hp
	health_component.heal(hp)


func _physics_process(_delta: float) -> void:
	var player = GameManager.player
	if not is_instance_valid(player):
		return

	var direction: Vector2 = (player.global_position - global_position).normalized()
	velocity = direction * speed * _time_scale

	move_and_slide()


func _on_hurt(_hitbox: Hitbox) -> void:
	health_component.take_damage(_hitbox.damage)
	sprite_flash.flash()


func _on_died() -> void:
	GameManager.enemies_remaining = max(0, GameManager.enemies_remaining - 1)
	GameManager.enemies_spawned = max(0, GameManager.enemies_spawned - 1)
	if GameManager.enemies_remaining == 0:
		SignalBus.gameover.emit()
	var smoke = smoke_scene.instantiate() as Node2D
	smoke.global_position = global_position
	get_tree().current_scene.add_child(smoke)
	queue_free()


func _on_hit(_hurtbox: Hurtbox) -> void:
	GameManager.enemies_spawned = max(0, GameManager.enemies_spawned - 1)
	queue_free()


func _on_slow_timer_timeout() -> void:
	slow_timer.wait_time = 5
	# Ease back to full speed (and fade the tint) instead of snapping.
	if _recover_tween:
		_recover_tween.kill()
	_recover_tween = create_tween()
	_recover_tween.set_parallel(true)
	_recover_tween.tween_property(self, "_time_scale", 1.0, SLOW_RECOVER_TIME)
	_recover_tween.tween_property(sprite, "self_modulate", Color.WHITE, SLOW_RECOVER_TIME)


func _on_slow_applied(time_scale: float) -> void:
	_apply_slow_visuals(time_scale)
	slow_timer.start()


func apply_slow(time_scale: float, wait_time: float) -> void:
	if time_scale == 1:
		return
	_apply_slow_visuals(time_scale)
	slow_timer.wait_time = wait_time
	slow_timer.start()


func _apply_slow_visuals(time_scale: float) -> void:
	if _recover_tween:
		_recover_tween.kill()
	_time_scale = time_scale
	sprite.self_modulate = slow_color
