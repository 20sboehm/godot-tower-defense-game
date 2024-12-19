extends Control

@onready var research_points: Label = %ResearchPointsLabel
@onready var back: Button = %Back

@onready var start_gold_title: Label = %StartGoldTitle
@onready var start_gold_current: Label = %StartGoldCurrent
@onready var start_gold_next: Label = %StartGoldNext
@onready var start_gold_upgrade: Button = %StartGoldUpgrade

@onready var wave_clear_award_title: Label = %WaveClearAwardTitle
@onready var wave_clear_award_current: Label = %WaveClearAwardCurrent
@onready var wave_clear_award_next: Label = %WaveClearAwardNext
@onready var wave_clear_award_upgrade: Button = %WaveClearAwardUpgrade

func _ready() -> void:
	back.button_down.connect(_on_back_button_down)
	start_gold_upgrade.button_down.connect(_on_start_gold_upgrade_button_down)
	wave_clear_award_upgrade.button_down.connect(_on_wave_clear_upgrade_button_down)

func _process(_delta: float) -> void:
	set_starting_gold_state()

func set_starting_gold_state() -> void:
	research_points.text = "RP: " + str(GameState.rp)
	
	set_update_button_state(GameC.upgrade_data[GameC.Upgrade.START_GOLD], GameState.start_gold_lvl,
		start_gold_title, start_gold_current, start_gold_next, start_gold_upgrade)
	set_update_button_state(GameC.upgrade_data[GameC.Upgrade.WAVE_CLEAR_AWARD], GameState.wave_clear_award_lvl,
		wave_clear_award_title, wave_clear_award_current, wave_clear_award_next, wave_clear_award_upgrade)

func set_update_button_state(upgrade_data: Dictionary, lvl: int, \
	title: Label, current: Label, next: Label, upgrade_button: Button) -> void:
	
	title.text = str(upgrade_data["label"]) + " (" + str(lvl) + "/" + str(upgrade_data["lvl_data"].size()) + ")"
	current.text = "Current: " + str(upgrade_data["lvl_data"][lvl]["value"]) + " gold"
	
	var disabled: bool = true
	if lvl == upgrade_data["lvl_data"].size(): # Upgrade is max level
		upgrade_button.text = "Max Level"
		next.text = "Next: " + "NA"
	else:
		upgrade_button.text = "Upgrade\n" + str(upgrade_data["lvl_data"][lvl + 1]["upgrade_cost"]) + " RP"
		next.text = "Next: " + str(upgrade_data["lvl_data"][lvl + 1]["value"]) + " gold"
		
		if GameState.rp >= upgrade_data["lvl_data"][lvl + 1]["upgrade_cost"]: # Enough RP
			disabled = false
	
	upgrade_button.disabled = disabled

func try_purchase_upgrade(upgrade_data: Dictionary, lvl: int) -> bool:
	if GameState.rp < upgrade_data["lvl_data"][lvl + 1]["upgrade_cost"] \
		or lvl == upgrade_data["lvl_data"].size():
		return false
	else:
		GameState.rp -= upgrade_data["lvl_data"][lvl + 1]["upgrade_cost"]
		return true

func _on_start_gold_upgrade_button_down() -> void:
	var upgrade_data: Dictionary = GameC.upgrade_data[GameC.Upgrade.START_GOLD]
	var lvl: int = GameState.start_gold_lvl
	
	if not try_purchase_upgrade(upgrade_data, lvl):
		return
	
	GameState.start_gold_lvl += 1

func _on_wave_clear_upgrade_button_down() -> void:
	var upgrade_data: Dictionary = GameC.upgrade_data[GameC.Upgrade.WAVE_CLEAR_AWARD]
	var lvl: int = GameState.wave_clear_award_lvl
	
	if not try_purchase_upgrade(upgrade_data, lvl):
		return
	
	GameState.wave_clear_award_lvl += 1

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")
