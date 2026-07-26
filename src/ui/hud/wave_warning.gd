extends Label


const TANK_COLOR := Color(0.9947894, 0, 0.22385535, 1)
const RUSH_COLOR := Color(1, 0.78, 0.2, 1)


func _ready() -> void:
	label_settings = preload("res://resources/label_settings/microwave_timer_white.tres")
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	offset_top = 64.0
	visible = false
	SignalBus.wave_incoming.connect(_on_wave_incoming)


func _on_wave_incoming(wave_name: String) -> void:
	text = "! %s INCOMING !" % wave_name
	self_modulate = TANK_COLOR if wave_name == "TANKS" else RUSH_COLOR
	modulate = Color.WHITE
	visible = true

	var tween := create_tween()
	tween.tween_interval(2.0)
	tween.tween_property(self, "modulate:a", 0.0, 1.5)
	tween.tween_callback(func() -> void: visible = false)
