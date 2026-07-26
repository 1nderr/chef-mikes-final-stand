class_name MicrowavePanel
extends Control

const DISABLED_MODULATE := Color(0.35, 0.35, 0.35, 1.0)

@onready var pizza_button: MicrowaveButton = $PizzaButton
@onready var popcorn_button: MicrowaveButton = $PopcornButton
@onready var icecream_button: MicrowaveButton = $IcecreamButton
@onready var label: Label = $Label

var _last_item: int = -1


func _ready() -> void:
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	SignalBus.microwave_done.connect(_on_microwave_done)
	for button in [pizza_button, popcorn_button, icecream_button]:
		button.pressed.connect(_on_button_pressed.bind(button.item))
	pizza_button.mouse_entered.connect(_on_pizza_button_mouse_entered)
	popcorn_button.mouse_entered.connect(_on_popcorn_button_mouse_entered)
	icecream_button.mouse_entered.connect(_on_icecream_button_mouse_entered)


func _on_button_pressed(item: Microwave.Item) -> void:
	_last_item = item


func _on_microwave_done(_item: Microwave.Item) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().set_deferred("paused", true)
	set_deferred("visible", true)
	label.text = "Select Food"
	_refresh_availability()


func _refresh_availability() -> void:
	for button in [pizza_button, popcorn_button, icecream_button]:
		var blocked: bool = button.item == _last_item
		button.disabled = blocked
		button.modulate = DISABLED_MODULATE if blocked else Color.WHITE


func _on_pizza_button_mouse_entered() -> void:
	label.text = "Pizza Disc\nOHKO, Slices thru\nCook Time: " + str(pizza_button.wait_time)


func _on_popcorn_button_mouse_entered() -> void:
	label.text = "Popcorn Bomb\n2 dmg, Big radius\nCook Time: " + str(popcorn_button.wait_time)


func _on_icecream_button_mouse_entered() -> void:
	label.text = "Icecream Freeze\nSlows time by 50%\nCook Time: " + str(icecream_button.wait_time)
