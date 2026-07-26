extends Node

const BASE_ENEMIES_TOTAL: int = 150
const WIN_INCREMENT: int = 25

var player: Player
var camera: ShakingCamera
var discs: int = 0
var bombs: int = 0
var slows: int = 0
var enemies_total: int = BASE_ENEMIES_TOTAL
var enemies_remaining: int = BASE_ENEMIES_TOTAL
var enemies_spawned: int = 0


func reset() -> void:
	discs = 0
	bombs = 0
	slows = 0
	enemies_remaining = enemies_total
	enemies_spawned = 0


func register_win() -> void:
	enemies_total += WIN_INCREMENT


func grant_powerup(item: Microwave.Item) -> void:
	match item:
		Microwave.Item.BOMB:
			bombs += 1
		Microwave.Item.SLOW:
			slows += 1
		Microwave.Item.DISC:
			discs += 1
