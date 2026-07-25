extends Node

@onready var start_button: Button = $Menu/Button
@onready var ding: AudioStreamPlayer2D = $DingSound
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	start_button.pressed.connect(_on_start_button)


func go_to_main():
	get_tree().change_scene_to_file("res://src/core/tutorial.tscn")


func _on_start_button():
	ding.play()
	animation_player.play("fade_out")
