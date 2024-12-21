class_name ArcherTower
extends Tower

func _ready() -> void:
	tower_type = GameC.TowerType.ARCHER
	initialize_tower()
	set_tower_level(lvl)

func _process(delta: float) -> void:
	cooldown_indicator.value = atk_cooldown_progress / atk_cooldown
	handle_attack_cooldown(delta)
	
	if not attack_ready:
		return
	
	var targets: Array[Area2D] = enemy_targeter.get_overlapping_areas()
	targets = targets.filter(
		func(target: Area2D) -> bool: return target.is_in_group("enemy") and not target.get_parent().is_dead
	)
	if not targets:
		return
	
	var closest_target: Area2D = get_closest_target(enemy_targeter.global_position, targets)
	var angle_to_target: float = get_angle_to_closest_target(closest_target)
	
	var new_arrow: Arrow = Arrow.create(
		angle_to_target,
		GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["pierce"],
		tower_range
	)
	
	enemy_targeter.add_child(new_arrow)
	attack_ready = false

func set_tower_level(_lvl: int) -> void:
	set_general_tower_level_data(_lvl)
