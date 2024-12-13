extends Control

@export var game_state: GameStateResource

@onready var fps_label: Label = $FPSLabel
@onready var archer_tower_button: Button = %ArcherTowerButton
@onready var fireball_tower_button: Button = %FireballTowerButton
@onready var zap_tower_button: Button = %ZapTowerButton
@onready var start_wave_button: Button = $StartWaveButton
@onready var game_speed_one_button: Button = $GameSpeed/GameSpeedOneButton
@onready var game_speed_two_button: Button = $GameSpeed/GameSpeedTwoButton
@onready var game_speed_four_button: Button = $GameSpeed/GameSpeedFourButton
@onready var game_speed_label: Label = $GameSpeed/GameSpeedLabel
@onready var wave_label: Label = $WaveLabel
@onready var money_label: Label = $MoneyLabel

@onready var tower_info_panel: Panel = $TowerInfoPanel
@onready var tower_type: Label = $TowerInfoPanel/TowerType
@onready var tower_level: Label = $TowerInfoPanel/TowerLevel
@onready var upgrade_button: Button = $TowerInfoPanel/UpgradeButton
@onready var sell_button: Button = $TowerInfoPanel/SellButton
@onready var upgrade_description_1: Label = $TowerInfoPanel/UpgradeDescriptions/UpgradeDescription1
@onready var upgrade_description_2: Label = $TowerInfoPanel/UpgradeDescriptions/UpgradeDescription2
@onready var upgrade_description_3: Label = $TowerInfoPanel/UpgradeDescriptions/UpgradeDescription3
@onready var upgrade_description_4: Label = $TowerInfoPanel/UpgradeDescriptions/UpgradeDescription4

@onready var wave_info_header: Label = $WaveInfoPanel/WaveInfoHeader
@onready var wave_enemies: Label = $WaveInfoPanel/WaveEnemies

func _ready() -> void:
	connect_signals()
	
	archer_tower_button.text = "Archer Tower\n" + "$" + str(GameC.t_data[GameC.TowerType.ARCHER]["cost"])
	fireball_tower_button.text = "Fireball Tower\n" + "$" + str(GameC.t_data[GameC.TowerType.FIREBALL]["cost"])
	zap_tower_button.text = "Zap Tower\n" + "$" + str(GameC.t_data[GameC.TowerType.ZAP]["cost"])


func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"
	
	wave_label.text = "Wave " + str(game_state.wave)
	money_label.text = "$" + str(game_state.money)
	game_speed_label.text = "Game Speed: " + str(Engine.time_scale) + "x"
	
	if game_state.wave_active:
		start_wave_button.disabled = true
		start_wave_button.text = "Wave " + str(game_state.wave) + " In Progress"
	elif game_state.wave > GameC.level_wave_data[game_state.level].size():
		start_wave_button.disabled = true
		start_wave_button.text = "Level complete!"
	else:
		start_wave_button.disabled = false
		start_wave_button.text = "Start Wave " + str(game_state.wave)
	
	#set_button_state(start_wave_button, game_state.wave_active, "Wave " + str(game_state.wave) + " In Progress",
		#"Start Wave " + str(game_state.wave))
	set_button_state(archer_tower_button, game_state.money < GameC.t_data[GameC.TowerType.ARCHER]["cost"])
	set_button_state(fireball_tower_button, game_state.money < GameC.t_data[GameC.TowerType.FIREBALL]["cost"])
	set_button_state(zap_tower_button, game_state.money < GameC.t_data[GameC.TowerType.ZAP]["cost"])
	
	set_upgrade_panel_state()
	
	set_wave_info_state()

func connect_signals() -> void:
	start_wave_button.button_down.connect(_on_start_wave_button_down)
	game_speed_one_button.button_down.connect(_on_game_speed_one_button_down)
	game_speed_two_button.button_down.connect(_on_game_speed_two_button_down)
	game_speed_four_button.button_down.connect(_on_game_speed_four_button_down)
	upgrade_button.button_down.connect(_on_upgrade_button_down)
	sell_button.button_down.connect(_on_sell_button_down)
	archer_tower_button.button_down.connect(_on_archer_tower_button_down)
	fireball_tower_button.button_down.connect(_on_fireball_tower_button_down)
	zap_tower_button.button_down.connect(_on_zap_tower_button_down)

func set_button_state(button: Button, disabledCondition: bool, disabledText: String = "",
						enabledText: String = "") -> void:
	if disabledCondition:
		button.disabled = true
		if disabledText:
			button.text = disabledText
	else:
		button.disabled = false
		if enabledText:
			button.text = enabledText

# TODO: you could have a boolean to tell this whether or not something has changed
func set_wave_info_state() -> void:
	if game_state.wave > GameC.level_wave_data[game_state.level].size():
		wave_enemies.text = ""
		wave_info_header.text = "Level complete!"
		return
	
	wave_info_header.text = "Wave " + str(game_state.wave)
	
	wave_enemies.text = ""
	
	var wave_data: Array = GameC.level_wave_data[game_state.level][game_state.wave]
	
	var enemy_amounts: Dictionary = {}
	
	for phase: Dictionary in wave_data:
		if phase["enemy_type"] in enemy_amounts:
			enemy_amounts[phase["enemy_type"]] += phase["count"]
		else:
			enemy_amounts[phase["enemy_type"]] = phase["count"]
	
	for enemy: GameC.EnemyType in enemy_amounts:
		wave_enemies.text += str(enemy_amounts[enemy]) + " " + str(GameC.e_data[enemy]["label"])
		if enemy_amounts[enemy] != 1:
			wave_enemies.text += "s" # Pluralize
		wave_enemies.text += "\n"

func set_upgrade_panel_state() -> void:
	if game_state.tower_selection == null:
		tower_info_panel.visible = false
		return
	
	tower_info_panel.visible = true
	
	var t_type: GameC.TowerType = game_state.tower_selection.tower_type
	var t_lvl: int = game_state.tower_selection.level
	
	tower_type.text = GameC.t_data[t_type]["label"]
	tower_level.text = "Level " + str(t_lvl)
	
	var grey: Color = Color(0.5, 0.5, 0.5, 1.0)
	var green: Color = Color(0, 0.5, 0, 1.0)
	
	var upgrade_descriptions: Array[Label] = [upgrade_description_1, upgrade_description_2, \
		upgrade_description_3, upgrade_description_4]
	
	var max_tower_lvl: int = GameC.t_data[t_type]["lvl_data"].size()
	for desc_id in range(1, upgrade_descriptions.size() + 1):
		var desc: Label = upgrade_descriptions[desc_id - 1]
		desc.add_theme_color_override("font_color", green)
		desc.visible = false
		if desc_id <= t_lvl + 1 and desc_id <= max_tower_lvl:
			desc.text = str(desc_id) + ": " + GameC.t_data[t_type]["lvl_data"][desc_id]["upgrade_desc"]
			desc.visible = true
			if desc_id == t_lvl + 1:
				desc.add_theme_color_override("font_color", grey)
	
	# Upgrade button
	if t_lvl >= GameC.t_data[t_type]["lvl_data"].size():
		upgrade_button.disabled = true
		upgrade_button.text = "Max Level"
	elif game_state.money < GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"]:
		upgrade_button.disabled = true
		upgrade_button.text = "Upgrade\n" + "$" + str(GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"])
	else:
		upgrade_button.disabled = false
		upgrade_button.text = "Upgrade\n" + "$" + str(GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"])
	
	# Sell button
	var sell_percent: float = 0.8
	var refund: int = GameC.t_data[t_type]["cost"] * sell_percent
	for upgrade_lvl in range(2, t_lvl + 1):
		refund += GameC.t_data[t_type]["lvl_data"][upgrade_lvl]["upgrade_cost"] * sell_percent
	sell_button.text = "Sell\n" + "$" + str(refund)

func _on_start_wave_button_down() -> void:
	SignalBus.wave_start.emit()

func _on_upgrade_button_down() -> void:
	SignalBus.upgrade_tower.emit()

func _on_sell_button_down() -> void:
	SignalBus.sell_tower.emit()

func _on_archer_tower_button_down() -> void:
	SignalBus.update_building_selection.emit(GameC.TowerType.ARCHER)

func _on_fireball_tower_button_down() -> void:
	SignalBus.update_building_selection.emit(GameC.TowerType.FIREBALL)

func _on_zap_tower_button_down() -> void:
	SignalBus.update_building_selection.emit(GameC.TowerType.ZAP)

func _on_game_speed_one_button_down() -> void:
	Engine.time_scale = 1.0

func _on_game_speed_two_button_down() -> void:
	Engine.time_scale = 2.0

func _on_game_speed_four_button_down() -> void:
	Engine.time_scale = 4.0
