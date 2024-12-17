extends Control

# TODO: save path should be global
var save_path: String = "user://game_state.save"

@export var game_state: Resource

@onready var select_level: Button = $SelectLevel
@onready var upgrades: Button = $Upgrades
@onready var main_menu: Button = $MainMenu
@onready var research_points: Label = $ResearchPointsLabel

func _ready() -> void:
	#DirAccess.remove_absolute(save_path)
	
	select_level.button_down.connect(_on_select_level_button_down)
	upgrades.button_down.connect(_on_upgrades_button_down)
	main_menu.button_down.connect(_on_main_menu_button_down)
	load_data()

func _process(_delta: float) -> void:
	research_points.text = "Research Points: " + str(game_state.rp)

# TODO: refactor loading
func load_data() -> void:
	print("Loading data")
	if FileAccess.file_exists(save_path):
		print("File exists")
		var file: FileAccess = FileAccess.open(save_path, FileAccess.READ)
		game_state.rp = file.get_var(game_state.rp)
		game_state.starting_gold = file.get_var(game_state.starting_gold)
		game_state.starting_gold_level = file.get_var(game_state.starting_gold_level)
	else:
		print("File does not exist")

func _on_select_level_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_level_select.tscn")

func _on_upgrades_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_upgrade.tscn")

func _on_main_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")
