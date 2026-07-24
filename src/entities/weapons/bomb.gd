class_name Bomb
extends Node2D

@export var big_bomb_collision: CircleShape2D

@onready var hitbox: Hitbox = $Hitbox
@onready var collision: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	GameManager.camera.screen_shake(3, 0.75)


func _process(delta: float) -> void:
	if not sprite.is_playing():
		queue_free()


func double() -> void:
	collision.shape = big_bomb_collision
