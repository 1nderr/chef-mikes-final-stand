extends Node

const ENEMIES_TOTAL: int = 100

var player: Player
var camera: ShakingCamera
var discs: int = 0
var bombs: int = 0
var slows: int = 0
var enemies_remaining: int = ENEMIES_TOTAL
var enemies_spawned: int = 0


func reset() -> void:
	discs = 0
	bombs = 0
	slows = 0
	enemies_remaining = ENEMIES_TOTAL
	enemies_spawned = 0


func grant_powerup(item: Microwave.Item) -> void:
	match item:
		Microwave.Item.BOMB:
			bombs += 1
		Microwave.Item.SLOW:
			slows += 1
		Microwave.Item.DISC:
			discs += 1
