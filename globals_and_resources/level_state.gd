extends Node

var level: int = 1
var wave: int = 1
var wave_active: bool = false
var level_won: bool = false
var level_lost: bool = false
var paused: bool = false

var tower_selection: Tower = null
var is_building: bool = false

var gold: int = 0
var earned_rp: int = 0 # Gained research points

func reset_level_state(_level: int, start_gold: int) -> void:
	level = _level
	wave = 1
	wave_active = false
	level_won = false
	level_lost = false
	tower_selection = null
	#gold = start_gold
	gold = 20000
	earned_rp = 0
