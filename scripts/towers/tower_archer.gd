class_name ArcherTower
extends Tower

func _ready() -> void:
	initialize_tower()
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
	
	var new_arrow: Arrow = Arrow.create(angle_to_target, GameConst.tower_level_data[tower_type][level]["pierce"], tower_range)
	enemy_targeter.add_child(new_arrow)
	
	attack_ready = false
	attack_timer.start()
