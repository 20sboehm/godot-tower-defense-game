class_name FireballTower
extends Tower

func _ready() -> void:
	tower_type = GameC.TowerType.FIREBALL
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
	
	var new_fireball: Fireball = Fireball.create(angle_to_target, tower_range, lvl)
	enemy_targeter.add_child(new_fireball)
	
	attack_ready = false

func set_tower_level(_lvl: int) -> void:
	set_general_tower_level_data(_lvl)
	#lvl = _lvl
	#tower_range = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["atk_range"]
	#atk_cooldown = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["atk_cooldown"]
	#collision_shape.shape.radius = tower_range
	#sprite.frame = _lvl - 1
	#atk_cooldown_progress = 0
