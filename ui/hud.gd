extends Control

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
@onready var gold_label: Label = $GoldLabel
@onready var earned_rp: Label = $EarnedRP

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

@onready var win_panel: Panel = $WinPanel
@onready var win_research_points_earned: Label = $WinPanel/ResearchPointsEarned
@onready var win_back_to_command_center: Button = $WinPanel/BackToCommandCenter

@onready var loss_panel: Panel = $LossPanel
@onready var loss_research_points_earned: Label = $LossPanel/ResearchPointsEarned
@onready var loss_back_to_command_center: Button = $LossPanel/BackToCommandCenter

func _ready() -> void:
	connect_signals()
	
	archer_tower_button.text = "Archer Tower\n" + str(GameC.t_data[GameC.TowerType.ARCHER]["cost"]) + "g"
	fireball_tower_button.text = "Fireball Tower\n" + str(GameC.t_data[GameC.TowerType.FIREBALL]["cost"]) + "g"
	zap_tower_button.text = "Zap Tower\n" + str(GameC.t_data[GameC.TowerType.ZAP]["cost"]) + "g"
	
	win_panel.visible = false
	loss_panel.visible = false

func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " FPS"
	
	wave_label.text = "Wave " + str(LevelState.wave) + "/" + str(GameC.level_wave_data[1].size())
	gold_label.text = "Gold (g): " + str(LevelState.gold)
	earned_rp.text = "Earned RP: " + str(LevelState.earned_rp)
	game_speed_label.text = "Game Speed: " + str(Engine.time_scale) + "x"
	
	if LevelState.wave_active:
		start_wave_button.disabled = true
		start_wave_button.text = "Wave " + str(LevelState.wave) + " In Progress"
	elif LevelState.level_won or LevelState.level_lost:
		start_wave_button.disabled = true
		start_wave_button.text = "Level over!"
	else:
		start_wave_button.disabled = false
		start_wave_button.text = "Start Wave " + str(LevelState.wave)
	
	set_button_state(archer_tower_button, LevelState.gold < GameC.t_data[GameC.TowerType.ARCHER]["cost"])
	set_button_state(fireball_tower_button, LevelState.gold < GameC.t_data[GameC.TowerType.FIREBALL]["cost"])
	set_button_state(zap_tower_button, LevelState.gold < GameC.t_data[GameC.TowerType.ZAP]["cost"])
	
	set_upgrade_panel_state()
	
	set_wave_info_state()
	
	if LevelState.level_won:
		level_won()
	
	if LevelState.level_lost:
		level_lost()

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
	win_back_to_command_center.button_down.connect(_on_back_to_command_center_button_down)
	loss_back_to_command_center.button_down.connect(_on_back_to_command_center_button_down)
	#SignalBus.level_over.connect(_on_level_over)

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
	if LevelState.level_won or LevelState.level_lost:
		wave_enemies.text = ""
		wave_info_header.text = "Level over!"
		return
	
	wave_info_header.text = "Wave " + str(LevelState.wave)
	
	wave_enemies.text = ""
	
	var wave_data: Array = GameC.level_wave_data[LevelState.level][LevelState.wave]
	
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
	if LevelState.tower_selection == null:
		tower_info_panel.visible = false
		return
	
	tower_info_panel.visible = true
	
	var t_type: GameC.TowerType = LevelState.tower_selection.tower_type
	var t_lvl: int = LevelState.tower_selection.level
	
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
	elif LevelState.gold < GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"]:
		upgrade_button.disabled = true
		upgrade_button.text = "Upgrade\n" + str(GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"]) + "g"
	else:
		upgrade_button.disabled = false
		upgrade_button.text = "Upgrade\n" + str(GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"]) + "g"
	
	# Sell button
	var sell_percent: float = 0.8
	var refund: int = GameC.t_data[t_type]["cost"] * sell_percent
	for upgrade_lvl in range(2, t_lvl + 1):
		refund += GameC.t_data[t_type]["lvl_data"][upgrade_lvl]["upgrade_cost"] * sell_percent
	sell_button.text = "Sell\n" + str(refund) + "g"

func level_won() -> void:
	if win_panel.visible == true:
		return
	var rp_text: String = "You earned " + str(LevelState.earned_rp) + " research points"
	win_research_points_earned.text = rp_text
	win_panel.visible = true

func level_lost() -> void:
	if loss_panel.visible == true:
		return
	var rp_text: String = "You earned " + str(LevelState.earned_rp) + " research points"
	loss_research_points_earned.text = rp_text
	loss_panel.visible = true

#func _on_level_over(win_or_loss: String) -> void:
	#GameState.rp += LevelState.earned_rp
	#var rp_text: String = "You earned " + str(LevelState.earned_rp) + " research points"
	#if win_or_loss == "win":
		#win_research_points_earned.text = rp_text
		#win_panel.visible = true
	#if win_or_loss == "loss":
		#loss_research_points_earned.text = rp_text
		#loss_panel.visible = true
	#GameState.save_game()

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

func _on_back_to_command_center_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")
