class_name FireballTower
extends Tower

func _ready() -> void:
	tower_type = GameC.TowerType.FIREBALL
	initialize_tower()
	set_tower_level(level)
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _process(_delta: float) -> void:
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
	
	var new_fireball: Fireball = Fireball.create(angle_to_target, tower_range)
	enemy_targeter.add_child(new_fireball)
	
	attack_ready = false
	attack_timer.start()

func set_tower_level(lvl: int) -> void:
	level = lvl
	attack_timer.wait_time = GameC.t_data[tower_type]["lvl_data"][level]["stats"]["attack_rate"]
	tower_range = GameC.t_data[tower_type]["lvl_data"][level]["stats"]["attack_range"]
	collision_shape.shape.radius = tower_range
	sprite.frame = lvl - 1
