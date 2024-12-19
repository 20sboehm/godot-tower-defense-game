extends Node

@onready var play: Button = %Play
@onready var settings: Button = %Settings
@onready var quit: Button = %Quit

func _ready() -> void:
	play.button_down.connect(_on_play_button_down)
	settings.button_down.connect(_on_settings_button_down)
	quit.button_down.connect(_on_quit_button_down)

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")

func _on_settings_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_settings.tscn")

func _on_quit_button_down() -> void:
	get_tree().quit()
