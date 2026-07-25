extends Node

@onready var start_button: Button = $CanvasLayer/Button


func _ready() -> void:
	start_button.pressed.connect(_on_start_button)


func go_to_main():
	get_tree().change_scene_to_file("res://src/core/main.tscn")


func _on_start_button():
	go_to_main()
