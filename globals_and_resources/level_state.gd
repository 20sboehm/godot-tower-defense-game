extends Node

var level: int = 1
var wave: int = 1
var wave_active: bool = false
var level_over: bool = false

var tower_selection: Tower = null

var gold: int = 0
var earned_rp: int = 0 # Gained research points

func reset_level_state(_level: int, starting_gold: int) -> void:
	level = _level
	wave = 1
	wave_active = false
	level_over = false
	tower_selection = null
	gold = starting_gold
	earned_rp = 0
