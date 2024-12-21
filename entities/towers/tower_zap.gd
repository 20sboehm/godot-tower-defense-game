class_name ZapTower
extends Tower

var total_zaps: int = 3

# Data for chain zaps
var initial_target: Area2D
var additional_zaps: int
var chain_range: int = 70

@onready var chain_timer: Timer = $EnemyTargeter/ChainTimer

func _ready() -> void:
	tower_type = GameC.TowerType.ZAP
	initialize_tower()
	set_tower_level(lvl)
	chain_timer.timeout.connect(_on_chain_timer_timeout)

func _process(delta: float) -> void:
	cooldown_indicator.value = atk_cooldown_progress / atk_cooldown
	handle_attack_cooldown(delta)
	
	if not attack_ready:
		return
	
	var targets: Array[Area2D] = enemy_targeter.get_overlapping_areas()
	targets = targets.filter(
		func(target: Area2D) -> bool: return target.is_in_group("enemy") and not target.get_parent().is_dead and not target.get_parent().is_zapped
	)
	if not targets:
		return
	
	var closest_target: Area2D = get_closest_target(enemy_targeter.global_position, targets)
	var midpoint_to_target: Vector2 = get_midpoint(enemy_targeter.global_position, closest_target.global_position)
	var relative_midpoint: Vector2 = midpoint_to_target - enemy_targeter.global_position
	var distance_to_target: float = (enemy_targeter.global_position).distance_to(closest_target.global_position)
	var angle_to_target: float = get_angle_to_closest_target(closest_target)
	
	# The zap is created by centering it in-between the tower and enemy and rotating it accordingly
	var new_zap: Zap = Zap.create(closest_target, relative_midpoint, distance_to_target, angle_to_target)
	enemy_targeter.add_child(new_zap)
	
	initial_target = closest_target
	additional_zaps = total_zaps - 1
	
	chain_timer.start()
	
	attack_ready = false

func _on_chain_timer_timeout() -> void:
	chain_zaps()

func get_midpoint(a: Vector2, b: Vector2) -> Vector2:
	return (a + b) / 2

# (Timer delayed) recursive function to chain zaps
func chain_zaps() -> void:
	if additional_zaps == 0:
		return
	
	var next_enemies: Array[Area2D] = []

	for node in get_tree().get_nodes_in_group("enemy"):
		if node is Area2D:
			next_enemies.append(node)
	
	next_enemies = next_enemies.filter(
		func(enemy: Area2D) -> bool: return not enemy.get_parent().is_dead \
			and not enemy.get_parent().is_zapped \
			and (initial_target.global_position).distance_to(enemy.global_position) < chain_range
	)
	if not next_enemies:
		return
	
	var closest_target: Area2D = get_closest_target(initial_target.global_position, next_enemies)
	var midpoint_to_target: Vector2 = get_midpoint(initial_target.global_position, closest_target.global_position)
	var relative_midpoint: Vector2 = midpoint_to_target - enemy_targeter.global_position
	var distance_to_target: float = (initial_target.global_position).distance_to(closest_target.global_position)
	var angle_to_target: float = initial_target.global_position.angle_to_point(closest_target.global_position)
	
	var new_zap: Zap = Zap.create(closest_target, relative_midpoint, distance_to_target, angle_to_target)
	enemy_targeter.add_child(new_zap)
	
	initial_target = closest_target
	additional_zaps -= 1
	
	chain_timer.start()

func set_tower_level(_lvl: int) -> void:
	set_general_tower_level_data(_lvl)
	total_zaps = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["zap_count"]

