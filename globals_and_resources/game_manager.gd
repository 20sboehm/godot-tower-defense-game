extends Node2D

# The tower to build.
var selected_tower_blueprint: GameC.TowerType = GameC.TowerType.NONE:
	set(new_selection):
		selected_tower_blueprint = new_selection
		if new_selection == GameC.TowerType.NONE:
			LevelState.is_building = false
			if icon.get_parent() != null: # Remove the icon if its in the scene
				remove_child(icon)
			return
		LevelState.is_building = true
		match (new_selection):
			GameC.TowerType.ARCHER:
				icon.set_texture(archer_tower_sprite)
			GameC.TowerType.FIREBALL:
				icon.set_texture(fireball_tower_sprite)
			GameC.TowerType.ZAP:
				icon.set_texture(zap_tower_sprite)
			GameC.TowerType.BEAM:
				icon.set_texture(beam_tower_sprite)
		icon.position = get_global_mouse_position()
		add_child(icon)

var icon: Sprite2D
var game: Node2D
var done_spawning: bool = false
var archer_tower_sprite: Resource = preload("res://entities/towers/tower_archer.png")
var fireball_tower_sprite: Resource = preload("res://entities/towers/tower_fireball.png")
var zap_tower_sprite: Resource = preload("res://entities/towers/tower_zap.png")
var beam_tower_sprite: Resource = preload("res://entities/towers/tower_beam.png")

@onready var spawner: Node2D = $Spawner
@onready var tile_map: TileMap = $TileMap

func _ready() -> void:
	#debug_calc_gold_at_each_wave()
	#debug_calc_total_slime_hp_of_each_wave()
	
	connect_signals()
	
	icon = Sprite2D.new()
	icon.hframes = 5
	icon.modulate = Color(1, 1, 1, 0.8)
	icon.position = get_global_mouse_position()
	icon.z_index = -5

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		selected_tower_blueprint = GameC.TowerType.NONE
		LevelState.tower_selection = null
		get_viewport().set_input_as_handled()
		return
	
	if LevelState.paused:
		return
	
	if event.is_action_pressed("left_mouse"):
		if selected_tower_blueprint == GameC.TowerType.NONE:
			LevelState.tower_selection = null
			return
		if LevelState.gold < GameC.t_data[selected_tower_blueprint]["cost"]:
			return
		
		var tower_pos: Vector2 = calc_grid_pos(get_global_mouse_position())
		if not check_buildable(tower_pos):
			return
		
		# Stop further propogation
		get_viewport().set_input_as_handled()
		
		LevelState.gold -= GameC.t_data[selected_tower_blueprint]["cost"]
		
		var new_tower: Tower
		match (selected_tower_blueprint):
			GameC.TowerType.ARCHER:
				new_tower = Tower.create(GameC.TowerType.ARCHER, tower_pos)
			GameC.TowerType.FIREBALL:
				new_tower = Tower.create(GameC.TowerType.FIREBALL, tower_pos)
			GameC.TowerType.ZAP:
				new_tower = Tower.create(GameC.TowerType.ZAP, tower_pos)
			GameC.TowerType.BEAM:
				new_tower = Tower.create(GameC.TowerType.BEAM, tower_pos)
		add_child(new_tower)
		
		selected_tower_blueprint = GameC.TowerType.NONE
		LevelState.tower_selection = new_tower

func _process(_delta: float) -> void:
	if selected_tower_blueprint != GameC.TowerType.NONE:
		var mouse_pos: Vector2 = calc_grid_pos(get_global_mouse_position())
		icon.position = mouse_pos
	
	if done_spawning == true and not get_tree().get_nodes_in_group("enemy"):
		done_spawning = false
		wave_over()
	
	queue_redraw()

func _draw() -> void:
	var white: Color = Color(1, 1, 1, 0.15)
	
	if LevelState.tower_selection:
		draw_circle(
			LevelState.tower_selection.global_position,
			LevelState.tower_selection.tower_range, 
			white
		)
		#draw_arc(LevelState.tower_selection.global_position, LevelState.tower_selection.tower_range, \
			#0, 360, 64, white, 1)
	
	var grey: Color = Color(1, 1, 1, 0.1)
	var mouse_grid_pos: Vector2 = calc_grid_pos(get_global_mouse_position())
	
	if selected_tower_blueprint != GameC.TowerType.NONE:
		draw_circle(
			mouse_grid_pos,
			GameC.t_data[selected_tower_blueprint]["lvl_data"][1]["stats"]["atk_range"],
			white
		)
		#draw_arc(mouse_grid_pos, GameC.t_data[selected_tower_blueprint]["lvl_data"][1]["stats"]["atk_range"], \
			#0, 360, 64, white, 1)
		
		
		draw_line(mouse_grid_pos + Vector2(-16, -32), mouse_grid_pos + Vector2(-16, 32), grey, 1)
		draw_line(mouse_grid_pos + Vector2(0, -32), mouse_grid_pos + Vector2(0, 32), grey, 1)
		draw_line(mouse_grid_pos + Vector2(16, -32), mouse_grid_pos + Vector2(16, 32), grey, 1)
		draw_line(mouse_grid_pos + Vector2(-32, -16), mouse_grid_pos + Vector2(32, -16), grey, 1)
		draw_line(mouse_grid_pos + Vector2(-32, 0), mouse_grid_pos + Vector2(32, 0), grey, 1)
		draw_line(mouse_grid_pos + Vector2(-32, 16), mouse_grid_pos + Vector2(32, 16), grey, 1)
		
		var valid_squares: Array = check_buildable_quadrants(mouse_grid_pos)
		
		place_rect(mouse_grid_pos, valid_squares[0], 0, -16)
		place_rect(mouse_grid_pos, valid_squares[1], -16, -16)
		place_rect(mouse_grid_pos, valid_squares[2], -16, 0)
		place_rect(mouse_grid_pos, valid_squares[3], 0, 0)

func connect_signals() -> void:
	SignalBus.wave_start.connect(_on_user_interface_wave_start)
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.update_building_selection.connect(_on_user_interface_update_building_selection)
	SignalBus.click_tower.connect(_on_tower_clicked)
	SignalBus.upgrade_tower.connect(_on_upgrade_tower)
	SignalBus.sell_tower.connect(_on_sell_tower)
	SignalBus.done_spawning.connect(_on_spawner_done_spawning)

func wave_over() -> void:
	LevelState.wave_active = false
	LevelState.gold += GameC.upgrade_data[GameC.Upgrade.WAVE_CLEAR_AWARD]["lvl_data"][GameState.wave_clear_award_lvl]["value"]
	
	if LevelState.wave >= GameC.level_wave_data[LevelState.level].size() \
		and not LevelState.level_won and not LevelState.level_lost:
		level_over()
	else:
		LevelState.wave += 1

func level_over() -> void:
	LevelState.level_won = true
	GameState.rp += LevelState.earned_rp
	GameState.save_game()

func place_rect(_mouse_grid_pos: Vector2, valid_square: bool, x: int, y: int) -> void:
	if valid_square:
		draw_rect(Rect2(_mouse_grid_pos + Vector2(x, y), Vector2(16, 16)), Color(0, 1, 0, 0.2))
	else:
		draw_rect(Rect2(_mouse_grid_pos + Vector2(x, y), Vector2(16, 16)), Color(1, 0, 0, 0.2))

func check_buildable(_pos: Vector2) -> bool:
	var checks: Array[Vector2] = [
		_pos + Vector2(8, 8),
		_pos + Vector2(-8, 8),
		_pos + Vector2(-8, -8),
		_pos + Vector2(8, -8)
	]
	
	var buildable: bool = true # Check if full tile area is buildable
	var no_collisions: bool = true # Check that it isn't colliding with another tower
	
	for check in checks:
		if not tile_map.is_buildable(check):
			buildable = false
		
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		query.collision_mask = 2
		query.position = check
		var result: Array[Dictionary] = space_state.intersect_point(query)
		if result != []:
			no_collisions = false
	
	return buildable and no_collisions

func check_buildable_quadrants(_pos: Vector2) -> Array[bool]:
	var checks: Array[Vector2] = [
		_pos + Vector2(8, -8), 
		_pos + Vector2(-8, -8), 
		_pos + Vector2(-8, 8), 
		_pos + Vector2(8, 8)
	]
	
	var quadrants: Array[bool] = []
	
	for i in range(checks.size()):
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
		query.collision_mask = 2
		query.position = checks[i]
		var result: Array[Dictionary] = space_state.intersect_point(query)
		
		if result == [] and tile_map.is_buildable(checks[i]):
			quadrants.append(true)
		else:
			quadrants.append(false)
	
	return quadrants

func calc_grid_pos(pos: Vector2) -> Vector2:
	var pos_x: int = snappedi(int(pos.x), 16)
	var pos_y: int = snappedi(int(pos.y), 16)
	return Vector2(pos_x, pos_y)

# Update tower building selection (for placing a tower).
func _on_user_interface_update_building_selection(tower_selection: GameC.TowerType) -> void:
	if LevelState.paused:
		return
	
	LevelState.tower_selection = null
	
	if selected_tower_blueprint == GameC.TowerType.NONE:
		selected_tower_blueprint = tower_selection
	else:
		selected_tower_blueprint = GameC.TowerType.NONE

func _on_user_interface_wave_start() -> void:
	LevelState.wave_active = true
	spawner.start_wave()

# Tower selection (for upgrades, selling, etc.)
func _on_tower_clicked(tower_clicked: Tower) -> void:
	if LevelState.paused or selected_tower_blueprint != GameC.TowerType.NONE:
		return
	
	LevelState.tower_selection = tower_clicked

func _on_enemy_killed(enemy: GameC.EnemyType) -> void:
	LevelState.gold += GameC.e_data[enemy]["gold_award"]
	LevelState.earned_rp += GameC.e_data[enemy]["rp_award"]

func _on_upgrade_tower() -> void:
	if LevelState.tower_selection == null or LevelState.paused:
		return
	
	var t_type: GameC.TowerType = LevelState.tower_selection.tower_type
	var t_lvl: int = LevelState.tower_selection.lvl
	if LevelState.gold < GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"]:
		return
	if t_lvl >= GameC.t_data[t_type]["lvl_data"].size():
		return
	
	LevelState.gold -= GameC.t_data[t_type]["lvl_data"][t_lvl + 1]["upgrade_cost"]
	LevelState.tower_selection.set_tower_level(t_lvl + 1)

func _on_sell_tower() -> void:
	if LevelState.tower_selection == null or LevelState.paused:
		return
	
	LevelState.tower_selection.queue_free()
	
	var t_type: GameC.TowerType = LevelState.tower_selection.tower_type
	var t_lvl: int = LevelState.tower_selection.lvl
	var sell_percent: float = 0.8
	var refund: int = GameC.t_data[t_type]["cost"] * sell_percent
	
	# A level 3 tower has 2 upgrades (and the cost of those upgrades are at indexes 2 and 3)
	# This loop would run for 'upgrade_lvl' = 2, 3 (and then stop)
	for upgrade_lvl in range(2, t_lvl + 1):
		refund += GameC.t_data[t_type]["lvl_data"][upgrade_lvl]["upgrade_cost"] * sell_percent
	
	LevelState.gold += refund
	
	LevelState.tower_selection = null

func _on_spawner_done_spawning() -> void:
	done_spawning = true

# Calculates how much gold the player will have at the start of each wave (without spending)
func debug_calc_gold_at_each_wave() -> void:
	# TODO: UPDATE THIS FUNCTION TO ACCOUNT FOR WAVE AWARD!!!
	var current_gold: int = LevelState.gold
	
	var waves: Dictionary = GameC.level_wave_data[LevelState.level]
	
	for i in range(1, waves.size() + 1):
		print("Wave " + str(i) + ": " + str(current_gold))
		current_gold += GameC.upgrade_data[GameC.Upgrade.WAVE_CLEAR_AWARD][GameState.wave_clear_award_lvl]["value"]
		for phase: Dictionary in waves[i]:
			current_gold += phase["count"] * GameC.e_data[phase["enemy_type"]]["gold_award"]

# Calculates the sum of slime HPs for every wave
func debug_calc_total_slime_hp_of_each_wave() -> void:
	var waves: Dictionary = GameC.level_wave_data[LevelState.level]
	
	for i in range(1, waves.size() + 1):
		var hp_sum: int = 0
		for phase: Dictionary in waves[i]:
			hp_sum += phase["count"] * GameC.e_data[phase["enemy_type"]]["hp"]
		print("Wave " + str(i) + ": " + str(hp_sum))
