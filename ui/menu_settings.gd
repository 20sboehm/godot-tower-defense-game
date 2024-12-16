extends Control

@onready var back: Button = $Back


func _ready() -> void:
	back.button_down.connect(_on_back_button_down)

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")
