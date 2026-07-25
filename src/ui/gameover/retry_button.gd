class_name RetryButton
extends TextureButton

func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_pressed() -> void:
	get_tree().reload_current_scene()


func _on_mouse_entered() -> void:
	self_modulate = Color(1.4, 1.4, 1.4, 1.0)


func _on_mouse_exited() -> void:
	self_modulate = Color(1.0, 1.0, 1.0, 1.0)
