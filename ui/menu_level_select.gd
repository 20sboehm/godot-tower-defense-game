extends Control

@export var game_state: Resource

@onready var level_1: Button = $Level1
@onready var back: Button = $Back

func _ready() -> void:
	level_1.button_down.connect(_on_level_1_button_down)
	back.button_down.connect(_on_back_button_down)

func _on_level_1_button_down() -> void:
	#LevelState.reset_level_state(1, game_state.starting_gold)
	LevelState.reset_level_state(1, GameC.upgrade_data["starting_gold"][game_state.starting_gold_level]["value"])
	get_tree().change_scene_to_file("res://levels/level_1.tscn")

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")
