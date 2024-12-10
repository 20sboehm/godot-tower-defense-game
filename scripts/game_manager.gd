extends Node2D

# The tower to build.
var selected_tower_blueprint: GameConst.Tower = GameConst.Tower.NONE:
	set(new_selection):
		selected_tower_blueprint = new_selection
		if new_selection == GameConst.Tower.NONE:
			remove_child(icon)
			return
		match (new_selection):
			GameConst.Tower.ARCHER:
				icon.set_texture(archer_tower_sprite)
			GameConst.Tower.FIREBALL:
				icon.set_texture(fireball_tower_sprite)
			GameConst.Tower.ZAP:
				icon.set_texture(zap_tower_sprite)
		icon.position = get_global_mouse_position()
		add_child(icon)

var icon: Sprite2D
var game: Node2D
var archer_tower_sprite: Resource = preload("res://assets/sprites/tower_archer.png")
var fireball_tower_sprite: Resource = preload("res://assets/sprites/tower_fireball.png")
var zap_tower_sprite: Resource = preload("res://assets/sprites/tower_zap.png")
@export var game_state: GameStateResource
@onready var spawner: Node2D = $Spawner

func _ready() -> void:
	connect_signals()
	
	icon = Sprite2D.new()
	icon.hframes = 5
	icon.modulate = Color(1, 1, 1, 0.5)
	icon.position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape"):
		selected_tower_blueprint = GameConst.Tower.NONE
	
	if event.is_action_pressed("left_mouse"):
		if selected_tower_blueprint == GameConst.Tower.NONE:
			game_state.tower_selection = null
			queue_redraw()
			return
		if game_state.money < GameConst.tower_costs[selected_tower_blueprint]:
			return
		
		# Stop further propogation
		get_viewport().set_input_as_handled()
		
		game_state.money -= GameConst.tower_costs[selected_tower_blueprint]
		var tower_pos: Vector2 = calc_grid_pos(get_global_mouse_position())
		
		var new_tower: Tower
		match (selected_tower_blueprint):
			GameConst.Tower.ARCHER:
				new_tower = Tower.create(GameConst.Tower.ARCHER, tower_pos)
			GameConst.Tower.FIREBALL:
				new_tower = Tower.create(GameConst.Tower.FIREBALL, tower_pos)
			GameConst.Tower.ZAP:
				new_tower = Tower.create(GameConst.Tower.ZAP, tower_pos)
		add_child(new_tower)
		
		selected_tower_blueprint = GameConst.Tower.NONE
		game_state.tower_selection = new_tower
		queue_redraw()

func _process(_delta: float) -> void:
	if selected_tower_blueprint != GameConst.Tower.NONE:
		icon.position = calc_grid_pos(get_global_mouse_position())

func _draw() -> void:
	#draw_arc(Vector2(0, 0), 90, 0, TAU, 64, Color.WHITE, 1.0)
	print("drawing!")
	print(game_state.tower_selection)
	if game_state.tower_selection:
		draw_circle(game_state.tower_selection.global_position, game_state.tower_selection.tower_range, Color(1, 1, 1, 0.1))

func connect_signals() -> void:
	SignalBus.wave_start.connect(_on_user_interface_wave_start)
	SignalBus.enemy_killed.connect(_on_enemy_killed)
	SignalBus.update_building_selection.connect(_on_user_interface_update_building_selection)
	SignalBus.click_tower.connect(_on_tower_clicked)
	SignalBus.upgrade_tower.connect(_on_upgrade_tower)
	SignalBus.sell_tower.connect(_on_sell_tower)

func calc_grid_pos(pos: Vector2) -> Vector2:
	var pos_x: int = snappedi(int(pos.x), 16)
	var pos_y: int = snappedi(int(pos.y), 16)
	return Vector2(pos_x, pos_y)

func _on_spawner_wave_over() -> void:
	game_state.wave_active = false
	game_state.wave += 1
	game_state.money += 100

# Update tower building selection (for placing a tower).
func _on_user_interface_update_building_selection(tower_selection: GameConst.Tower) -> void:
	if selected_tower_blueprint == GameConst.Tower.NONE:
		selected_tower_blueprint = tower_selection
	else:
		selected_tower_blueprint = GameConst.Tower.NONE

func _on_user_interface_wave_start() -> void:
	game_state.wave_active = true
	spawner.start_wave()

# Update tower selection (for upgrades, selling, etc.)
func _on_tower_clicked(tower_clicked: Tower) -> void:
	game_state.tower_selection = tower_clicked
	queue_redraw()

func _on_enemy_killed(enemy: GameConst.Enemy) -> void:
	game_state.money += GameConst.enemy_kill_awards[enemy]

func _on_upgrade_tower() -> void:
	if game_state.tower_selection == null:
		return
	
	var t_type: GameConst.Tower = game_state.tower_selection.tower_type
	var t_lvl: int = game_state.tower_selection.level
	if game_state.money < GameConst.tower_upgrade_costs[t_type][t_lvl + 1]:
		return
	# Ensure it won't upgrade past the max tower level
	if t_lvl >= GameConst.tower_level_data[t_type].size():
		return
	
	game_state.money -= GameConst.tower_upgrade_costs[t_type][t_lvl + 1]
	game_state.tower_selection.set_tower_level(t_lvl + 1)
	
	queue_redraw()

func _on_sell_tower() -> void:
	if game_state.tower_selection == null:
		return
	
	game_state.tower_selection.queue_free()
	
	var t_type: GameConst.Tower = game_state.tower_selection.tower_type
	var t_lvl: int = game_state.tower_selection.level
	var sell_percent: float = 0.8
	var refund: int = GameConst.tower_costs[t_type] * sell_percent
	
	# A level 3 tower has 2 upgrades (and the cost of those upgrades are at indexes 2 and 3)
	# This loop would run for 'upgrade_lvl' = 2, 3 (and then stop)
	for upgrade_lvl in range(2, t_lvl + 1):
		refund += GameConst.tower_upgrade_costs[t_type][upgrade_lvl] * sell_percent
	
	game_state.money += refund
	
	game_state.tower_selection = null
	queue_redraw()
