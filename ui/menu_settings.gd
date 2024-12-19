extends Control

@onready var resolution_option: OptionButton = %ResolutionOption
@onready var window_mode_option: OptionButton = %WindowModeOption
@onready var back: Button = %Back

func _ready() -> void:
	connect_signals()
	
	if GameState.resolution == GameState.Resolution.TEN_EIGHTY_P:
		resolution_option.selected = 1

func _process(_delta: float) -> void:
	var is_fullscreen: bool = GameState.window_mode == GameState.WindowMode.FULLSCREEN
	resolution_option.disabled = is_fullscreen
	window_mode_option.selected = 1 if is_fullscreen else 0

func connect_signals() -> void:
	back.button_down.connect(_on_back_button_down)
	resolution_option.item_selected.connect(_on_resolution_option_selected)
	window_mode_option.item_selected.connect(_on_window_mode_option_selected)

func center_window() -> void:
	var screen_center: Vector2i = DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2
	var window_size: Vector2i = get_window().get_size_with_decorations()
	get_window().set_position(screen_center - window_size / 2)

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_main.tscn")

func set_resolution() -> void:
	match (GameState.resolution):
		GameState.Resolution.FIVE_FOURTY_P:
			get_window().size = Vector2i(960, 540)
		GameState.Resolution.TEN_EIGHTY_P:
			get_window().size = Vector2i(1920, 1080)
	center_window()

func _on_resolution_option_selected(index: int) -> void:
	GameState.resolution = index as GameState.Resolution
	set_resolution()

func _on_window_mode_option_selected(index: int) -> void:
	if index == 0:
		GameState.window_mode = GameState.WindowMode.WINDOWED
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		set_resolution()
	elif index == 1:
		GameState.window_mode = GameState.WindowMode.FULLSCREEN
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
