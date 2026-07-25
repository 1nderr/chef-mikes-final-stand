class_name SpriteFlash
extends Node

@export var sprite: AnimatedSprite2D


func flash() -> void:
	var tween = create_tween()
	sprite.modulate = Color.RED
	tween.tween_property(sprite, "modulate", Color.WHITE, 0.25)
