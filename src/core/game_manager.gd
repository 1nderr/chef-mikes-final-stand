extends Node

const ENEMIES_TOTAL: int = 100

var player: Player
var camera: ShakingCamera
var discs: int = 1
var bombs: int = 1
var slows: int = 1
var enemies_remaining: int = ENEMIES_TOTAL
var enemies_spawned: int = 0


func reset() -> void:
	discs = 1
	bombs = 1
	slows = 1
	enemies_remaining = ENEMIES_TOTAL
	enemies_spawned = 0
