class_name ItemDisplay
extends Control

@onready var pizza_label: Label = $Counts/Label
@onready var popcorn_label: Label = $Counts/Label2
@onready var icecream_label: Label = $Counts/Label3


func _process(_delta: float) -> void:
	pizza_label.text = str(GameManager.discs)
	popcorn_label.text = str(GameManager.bombs)
	icecream_label.text = str(GameManager.slows)
