extends Control

@onready var research_points_label: Label = $ResearchPointsLabel
@onready var back: Button = $Back

@onready var start_gold_title: Label = $StartGold/StartGoldTitle
@onready var start_gold_current: Label = $StartGold/StartGoldCurrent
@onready var start_gold_next: Label = $StartGold/StartGoldNext
@onready var start_gold_upgrade: Button = $StartGold/StartGoldUpgrade

func _ready() -> void:
	back.button_down.connect(_on_back_button_down)
	start_gold_upgrade.button_down.connect(_on_start_gold_upgrade_button_down)

func _process(_delta: float) -> void:
	set_starting_gold_state()

func set_starting_gold_state() -> void:
	# sg = Start Gold
	var sg_upgrade_data: Dictionary = GameC.upgrade_data["start_gold"]
	var sg_lvl: int = GameState.start_gold_lvl
	
	research_points_label.text = "RP: " + str(GameState.rp)
	start_gold_title.text = "Starting Gold " + "(" + str(sg_lvl) + "/" + str(sg_upgrade_data.size()) + ")"
	start_gold_current.text = "Current: " + str(sg_upgrade_data[sg_lvl]["value"]) + " gold"
	
	var disabled: bool = true
	if GameState.start_gold_lvl == sg_upgrade_data.size(): # Upgrade is max level
		start_gold_upgrade.text = "Max Level"
		start_gold_next.text = "Next: " + "NA"
	else:
		start_gold_upgrade.text = "Upgrade\n" + str(sg_upgrade_data[sg_lvl + 1]["upgrade_cost"]) + " RP"
		start_gold_next.text = "Next: " + str(sg_upgrade_data[sg_lvl + 1]["value"]) + " gold"
		
		if GameState.rp >= sg_upgrade_data[sg_lvl + 1]["upgrade_cost"]: # Enough RP
			disabled = false
	
	start_gold_upgrade.disabled = disabled

func _on_start_gold_upgrade_button_down() -> void:
	var sg_upgrade_data: Dictionary = GameC.upgrade_data["start_gold"]
	var sg_lvl: int = GameState.start_gold_lvl
	
	if GameState.rp < sg_upgrade_data[sg_lvl + 1]["upgrade_cost"] or \
		sg_lvl == sg_upgrade_data.size():
		return
	
	GameState.rp -= sg_upgrade_data[sg_lvl + 1]["upgrade_cost"]
	GameState.start_gold_lvl += 1
	GameState.save_game()

func _on_back_button_down() -> void:
	get_tree().change_scene_to_file("res://ui/menu_command_center.tscn")
