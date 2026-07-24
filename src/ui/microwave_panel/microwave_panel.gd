class_name MicrowavePanel
extends Control

@onready var pizza_button: TextureButton = $PizzaButton
@onready var popcorn_button: TextureButton = $PopcornButton
@onready var icecream_button: TextureButton = $IcecreamButton
@onready var label: Label = $Label


func _ready() -> void:
	get_tree().paused = true
	SignalBus.microwave_done.connect(_on_microwave_done)
	pizza_button.mouse_entered.connect(_on_pizza_button_mouse_entered)
	popcorn_button.mouse_entered.connect(_on_popcorn_button_mouse_entered)
	icecream_button.mouse_entered.connect(_on_icecream_button_mouse_entered)


func _on_microwave_done(_item: Microwave.Item) -> void:
	get_tree().paused = true
	visible = true
	label.text = "Select Food"


func _on_pizza_button_mouse_entered() -> void:
	return


func _on_popcorn_button_mouse_entered() -> void:
	label.text = "Popcorn Bomb\nBlasts enemies\nCook Time: 10"
	return


func _on_icecream_button_mouse_entered() -> void:
	label.text = "Icecream Freeze\nSlows enemies\nCook Time: 20"
	return
