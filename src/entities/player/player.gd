class_name Player
extends Node2D

@export var bullet_scene: PackedScene
@export var bomb_scene: PackedScene
@export var heart_scene: PackedScene

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent
@onready var bomb_aim: BombAim = $BombAim

var _can_shoot = true


func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	SignalBus.microwave_done.connect(_on_microwave_done)
	SignalBus.healed.connect(_on_healed)
	GameManager.player = self


func _process(_delta: float) -> void:
	if _can_shoot and Input.is_action_pressed("shoot"):
		shoot()


func _unhandled_input(event: InputEvent) -> void:
	if GameManager.bombs > 0 and event.is_action_pressed("bomb"):
		throw_bomb()
	elif GameManager.slows > 0 and event.is_action_pressed("slow"):
		SignalBus.slow_applied.emit(0.5)


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
	get_tree().current_scene.add_child(bomb)
	GameManager.bombs = max(GameManager.bombs - 1, 0)


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _on_hurt(hitbox: Hitbox) -> void:
	GameManager.camera.screen_shake(1, 0.5)
	health_component.take_damage(hitbox.damage)
	SignalBus.health_updated.emit(health_component.get_hp())


func _on_healed() -> void:
	_spawn_heart()
	health_component.heal(1)
	SignalBus.health_updated.emit(health_component.get_hp())


func _on_died() -> void:
	SignalBus.player_died.emit()
	queue_free()


func _spawn_heart() -> void:
	var heart := heart_scene.instantiate() as Node2D
	heart.global_position = global_position
	owner.add_child(heart)


func _on_microwave_done(item: Microwave.Item) -> void:
	if item == Microwave.Item.BOMB:
		GameManager.bombs += 1
	elif item == Microwave.Item.SLOW:
		GameManager.slows += 1
	elif item == Microwave.Item.DISC:
		GameManager.discs += 1
