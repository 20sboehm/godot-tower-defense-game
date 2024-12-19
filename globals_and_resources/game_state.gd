extends Node

var save_path: String = "user://savegame.save"

enum WindowMode {
	WINDOWED,
	FULLSCREEN,
}

enum Resolution {
	FIVE_FOURTY_P,
	TEN_EIGHTY_P,
}

@export var rp: int = 0: # Research Points: used for upgrades
	set(val):
		rp = val
		save_game()
@export var window_mode: WindowMode = WindowMode.WINDOWED:
	set(val):
		window_mode = val
		save_game()
@export var resolution: Resolution = Resolution.FIVE_FOURTY_P:
	set(val):
		resolution = val
		save_game()

@export var start_gold_lvl: int = 1:
	set(val):
		start_gold_lvl = val
		save_game()
@export var wave_clear_award_lvl: int = 1:
	set(val):
		wave_clear_award_lvl = val
		save_game()

func _ready() -> void:
	#DirAccess.remove_absolute(save_path)
	#print(OS.get_data_dir())
	load_game()
	set_window_and_resolution()

func center_window() -> void:
	var screen_center: Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size: Vector2i = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)

func set_window_and_resolution() -> void:
	if window_mode == WindowMode.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		match (resolution):
			Resolution.FIVE_FOURTY_P:
				get_window().size = Vector2i(960, 540)
			Resolution.TEN_EIGHTY_P:
				get_window().size = Vector2i(1920, 1080)
		center_window()

func save_game() -> void:
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.WRITE)
	var save_data: Dictionary = {
		"rp": rp,
		"start_gold_lvl": start_gold_lvl,
		"window_mode": window_mode,
		"resolution": resolution,
		"wave_clear_award_lvl": wave_clear_award_lvl,
	}
	var json_string: String = JSON.stringify(save_data)
	save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists(save_path):
		save_game()
		return
	
	var save_file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
	var json_string: String = save_file.get_line()
	var json: JSON = JSON.new()
	json.parse(json_string)
	var save_data: Variant = json.data
	
	rp = save_data["rp"]
	start_gold_lvl = save_data["start_gold_lvl"]
	window_mode = save_data["window_mode"]
	resolution = save_data["resolution"]
	wave_clear_award_lvl = save_data["wave_clear_award_lvl"]

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
