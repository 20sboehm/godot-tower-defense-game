extends Control

@export var game_state: GameStateResource

@onready var fps_label: Label = $FPSLabel
@onready var archer_tower_button: Button = %ArcherTowerButton
@onready var fireball_tower_button: Button = %FireballTowerButton
@onready var zap_tower_button: Button = %ZapTowerButton
@onready var start_wave_button: Button = $StartWaveButton
@onready var wave_label: Label = $WaveLabel
@onready var money_label: Label = $MoneyLabel

@onready var panel: Panel = $Panel
@onready var tower_type: Label = $Panel/TowerType
@onready var tower_level: Label = $Panel/TowerLevel
@onready var upgrade_button: Button = $Panel/UpgradeButton
@onready var sell_button: Button = $Panel/SellButton

@onready var upgrade_description_1: Label = $Panel/UpgradeDescriptions/UpgradeDescription1
@onready var upgrade_description_2: Label = $Panel/UpgradeDescriptions/UpgradeDescription2
@onready var upgrade_description_3: Label = $Panel/UpgradeDescriptions/UpgradeDescription3
@onready var upgrade_description_4: Label = $Panel/UpgradeDescriptions/UpgradeDescription4

func _ready() -> void:
	connect_signals()
	
	archer_tower_button.text = "Archer Tower\n" + "$" + str(GameConst.tower_costs[GameConst.Tower.ARCHER])
	fireball_tower_button.text = "Fireball Tower\n" + "$" + str(GameConst.tower_costs[GameConst.Tower.FIREBALL])
	zap_tower_button.text = "Zap Tower\n" + "$" + str(GameConst.tower_costs[GameConst.Tower.ZAP])

func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second())
	
	wave_label.text = "Wave " + str(game_state.wave)
	money_label.text = "$" + str(game_state.money)
	
	set_button_state(start_wave_button, game_state.wave_active, "Wave " + str(game_state.wave) + " In Progress",
		"Start Wave " + str(game_state.wave))
	set_button_state(archer_tower_button, game_state.money < GameConst.tower_costs[GameConst.Tower.ARCHER])
	set_button_state(fireball_tower_button, game_state.money < GameConst.tower_costs[GameConst.Tower.FIREBALL])
	set_button_state(zap_tower_button, game_state.money < GameConst.tower_costs[GameConst.Tower.ZAP])
	
	set_upgrade_panel_state()

func connect_signals() -> void:
	start_wave_button.button_down.connect(_on_start_wave_button_down)
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

func set_upgrade_panel_state() -> void:
	if game_state.tower_selection == null:
		panel.visible = false
		return
	
	panel.visible = true
	
	var t_type: GameConst.Tower = game_state.tower_selection.tower_type
	var t_lvl: int = game_state.tower_selection.level
	
	tower_type.text = GameConst.tower_labels[t_type]
	tower_level.text = "Level " + str(t_lvl)
	
	var grey: Color = Color(0.5, 0.5, 0.5, 1.0)
	var green: Color = Color(0, 0.5, 0, 1.0)
	
	var upgrade_descriptions: Array[Label] = [upgrade_description_1, upgrade_description_2, \
		upgrade_description_3, upgrade_description_4]
	
	var max_tower_lvl: int = GameConst.tower_upgrade_descriptions[t_type].size()
	for desc_id in range(1, upgrade_descriptions.size() + 1):
		var desc: Label = upgrade_descriptions[desc_id - 1]
		desc.add_theme_color_override("font_color", green)
		desc.visible = false
		if desc_id <= t_lvl + 1 and desc_id <= max_tower_lvl:
			desc.text = str(desc_id) + ": " + GameConst.tower_upgrade_descriptions[t_type][desc_id]
			desc.visible = true
			if desc_id == t_lvl + 1:
				desc.add_theme_color_override("font_color", grey)
	
	# Upgrade button
	if t_lvl >= GameConst.tower_level_data[t_type].size():
		upgrade_button.disabled = true
		upgrade_button.text = "Max Level"
	elif game_state.money < GameConst.tower_upgrade_costs[t_type][t_lvl + 1]:
		upgrade_button.disabled = true
		upgrade_button.text = "Upgrade\n" + "$" + str(GameConst.tower_upgrade_costs[t_type][t_lvl + 1])
	else:
		upgrade_button.disabled = false
		upgrade_button.text = "Upgrade\n" + "$" + str(GameConst.tower_upgrade_costs[t_type][t_lvl + 1])
	
	# Sell button
	var sell_percent: float = 0.8
	var refund: int = GameConst.tower_costs[t_type] * sell_percent
	for upgrade_lvl in range(2, t_lvl + 1):
		refund += GameConst.tower_upgrade_costs[t_type][upgrade_lvl] * sell_percent
	sell_button.text = "Sell\n" + "$" + str(refund)

func _on_start_wave_button_down() -> void:
	SignalBus.wave_start.emit()

func _on_upgrade_button_down() -> void:
	SignalBus.upgrade_tower.emit()

func _on_sell_button_down() -> void:
	SignalBus.sell_tower.emit()

func _on_archer_tower_button_down() -> void:
	SignalBus.update_building_selection.emit(GameConst.Tower.ARCHER)

func _on_fireball_tower_button_down() -> void:
	SignalBus.update_building_selection.emit(GameConst.Tower.FIREBALL)

func _on_zap_tower_button_down() -> void:
	SignalBus.update_building_selection.emit(GameConst.Tower.ZAP)
