extends Node

var save_path: String = "user://savegame.save"

@export var rp: int = 0 # Research Points: used for upgrades
#@export var start_gold: int = 0
@export var start_gold_lvl: int = 1

func _ready() -> void:
	#DirAccess.remove_absolute(save_path)
	#print(OS.get_data_dir())
	load_game()

func save_game() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	var save_data: Dictionary = {
		"rp": rp,
		#"start_gold": start_gold,
		"start_gold_lvl": start_gold_lvl,
	}
	var json_string: String = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists(save_path):
		return
	
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	var json_string: String = save_file.get_line()
	var json: JSON = JSON.new()
	json.parse(json_string)
	var save_data: Variant = json.data
	rp = save_data["rp"]
	#start_gold = save_data["start_gold"]
	start_gold_lvl = save_data["start_gold_lvl"]

#func save() -> void:
	#var file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	#file.store_var(rp)
	#file.store_var(start_gold)
	#file.store_var(start_gold_lvl)
#
#func load_data() -> void:
	#if FileAccess.file_exists(save_path):
		#var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		#rp = file.get_var(rp)
		#start_gold = file.get_var(start_gold)
		#start_gold_lvl = file.get_var(start_gold_lvl)
