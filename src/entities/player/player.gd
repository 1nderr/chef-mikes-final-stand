class_name Player
extends Node2D

@export var bullet_scene: PackedScene
@export var bomb_scene: PackedScene
@export var disc_scene: PackedScene
@export var heart_scene: PackedScene
@export var smoke_scene: PackedScene

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var hurtbox: Hurtbox = $Hurtbox
@onready var health_component: HealthComponent = $HealthComponent
@onready var bomb_aim: BombAim = $BombAim
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_flash: SpriteFlash = $SpriteFlash
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var ice_sound: AudioStreamPlayer2D = $IceSound
@onready var skill_sound: AudioStreamPlayer2D = $SkillSound

var _can_shoot = true
var _can_slow = true


func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)
	health_component.died.connect(_on_died)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	SignalBus.healed.connect(_on_healed)
	SignalBus.slow_done.connect(_on_slow_done)
	SignalBus.microwave_start.connect(_on_microwave_start)
	GameManager.player = self


func _process(_delta: float) -> void:
	if _can_shoot and Input.is_action_pressed("shoot"):
		shoot()


func _unhandled_input(event: InputEvent) -> void:
	if GameManager.bombs > 0 and event.is_action_pressed("bomb"):
		throw_bomb()
	elif GameManager.discs > 0 and event.is_action_pressed("disc"):
		throw_disc()
	elif GameManager.slows > 0 and _can_slow and event.is_action_pressed("slow"):
		SignalBus.slow_applied.emit(0.5)
		ice_sound.play()
		GameManager.slows = max(GameManager.slows - 1, 0)
		_can_slow = false


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


func throw_disc() -> void:
	var disc = disc_scene.instantiate() as Disc
	disc.global_position = global_position
	disc.target_position = get_global_mouse_position()
	get_tree().current_scene.add_child(disc)
	GameManager.discs = max(GameManager.discs - 1, 0)


func _on_slow_done() -> void:
	_can_slow = true


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _on_hurt(hitbox: Hitbox) -> void:
	GameManager.camera.screen_shake(1, 0.5)
	health_component.take_damage(hitbox.damage)
	SignalBus.health_updated.emit(health_component.get_hp())
	hurt_sound.play()
	sprite_flash.flash()


func _on_healed() -> void:
	skill_sound.play()
	_spawn_heart()
	animation_player.play("flash")
	health_component.heal(1)
	SignalBus.health_updated.emit(health_component.get_hp())


func _on_microwave_start(_item: Microwave.Item, _wait_time: float) -> void:
	animation_player.play("RESET")


func _on_died() -> void:
	var smoke = smoke_scene.instantiate() as Node2D
	smoke.global_position = global_position
	get_tree().current_scene.add_child(smoke)
	SignalBus.player_died.emit()
	queue_free()


func _spawn_heart() -> void:
	var heart := heart_scene.instantiate() as Node2D
	heart.global_position = global_position
	heart.global_position.x -= 16
	owner.add_child(heart)


