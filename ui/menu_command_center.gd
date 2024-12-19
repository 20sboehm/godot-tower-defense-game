extends Control

@onready var research_points: Label = %ResearchPointsLabel
@onready var select_level: Button = %SelectLevel
@onready var upgrades: Button = %Upgrades
@onready var main_menu: Button = %MainMenu

func _ready() -> void:
	select_level.button_down.connect(_on_select_level_button_down)
	upgrades.button_down.connect(_on_upgrades_button_down)
	main_menu.button_down.connect(_on_main_menu_button_down)

func _process(_delta: float) -> void:
	research_points.text = "RP: " + str(GameState.rp)

func _on_select_level_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_level_select.tscn")

func _on_upgrades_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_upgrade.tscn")

func _on_main_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")
