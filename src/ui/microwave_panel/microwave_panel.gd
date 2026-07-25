class_name MicrowavePanel
extends Control

@onready var pizza_button: MicrowaveButton = $PizzaButton
@onready var popcorn_button: MicrowaveButton = $PopcornButton
@onready var icecream_button: MicrowaveButton = $IcecreamButton
@onready var label: Label = $Label


func _ready() -> void:
	get_tree().paused = true
	SignalBus.microwave_done.connect(_on_microwave_done)
	pizza_button.mouse_entered.connect(_on_pizza_button_mouse_entered)
	popcorn_button.mouse_entered.connect(_on_popcorn_button_mouse_entered)
	icecream_button.mouse_entered.connect(_on_icecream_button_mouse_entered)


func _on_microwave_done(_item: Microwave.Item) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().set_deferred("paused", true)
	set_deferred("visible", true)
	label.text = "Select Food"


func _on_pizza_button_mouse_entered() -> void:
	label.text = "Pizza Disc\nSlices through\nCook Time: " + str(pizza_button.wait_time)


func _on_popcorn_button_mouse_entered() -> void:
	label.text = "Popcorn Bomb\nBlasts enemies\nCook Time: " + str(popcorn_button.wait_time)


func _on_icecream_button_mouse_entered() -> void:
	label.text = "Icecream Freeze\nSlows time by 50%\nCook Time: " + str(icecream_button.wait_time)
