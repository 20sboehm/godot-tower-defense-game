extends Control

@export var game_state: Resource

@onready var research_points: Label = $ResearchPointsLabel
@onready var starting_gold_upgrade: Button = $StartingGoldUpgrade
@onready var back: Button = $Back

func _ready() -> void:
	back.button_down.connect(_on_back_button_down)
	starting_gold_upgrade.button_down.connect(_on_starting_gold_upgrade_button_down)

func _process(_delta: float) -> void:
	research_points.text = "Research Points: " + str(game_state.rp)
	starting_gold_upgrade.text = "Upgrade Starting Gold\n" \
		+ str(GameC.upgrade_data["starting_gold"][game_state.starting_gold_level + 1]["upgrade_cost"]) + " RP"
	
	if game_state.rp < GameC.upgrade_data["starting_gold"][game_state.starting_gold_level + 1]["upgrade_cost"]:
		starting_gold_upgrade.disabled = true
	else:
		starting_gold_upgrade.disabled = false

func _on_starting_gold_upgrade_button_down() -> void:
	if game_state.rp < GameC.upgrade_data["starting_gold"][game_state.starting_gold_level + 1]["upgrade_cost"]:
		return
	
	game_state.rp -= GameC.upgrade_data["starting_gold"][game_state.starting_gold_level + 1]["upgrade_cost"]
	game_state.starting_gold_level += 1

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")
