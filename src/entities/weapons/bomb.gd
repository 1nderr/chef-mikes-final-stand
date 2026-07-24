class_name Bomb
extends Node2D

@export var big_bomb_collision: CircleShape2D

@onready var hitbox: Hitbox = $Hitbox
@onready var collision: CollisionShape2D = $Hitbox/CollisionShape2D


func _ready() -> void:
	hitbox.hit.connect(_on_hit)


func _on_hit(_hurtbox: Hurtbox) -> void:
	queue_free()


func double() -> void:
	collision.shape = big_bomb_collision
