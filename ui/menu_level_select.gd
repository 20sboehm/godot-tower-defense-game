extends Control

@onready var level_1: Button = %Level1
@onready var level_2: Button = %Level2
@onready var back: Button = %Back

func _ready() -> void:
	level_1.button_down.connect(_on_level_1_button_down)
	level_2.button_down.connect(_on_level_2_button_down)
	back.button_down.connect(_on_back_button_down)

func _on_level_1_button_down() -> void:
	LevelState.reset_level_state(1, GameC.upgrade_data[GameC.Upgrade.START_GOLD]["lvl_data"][GameState.start_gold_lvl]["value"])
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_level_2_button_down() -> void:
	LevelState.reset_level_state(2, GameC.upgrade_data[GameC.Upgrade.START_GOLD]["lvl_data"][GameState.start_gold_lvl]["value"])
	get_tree().change_scene_to_file("res://levels/level_2.tscn")

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")
