extends SlimeBase

var attack_ready: bool = true

@onready var health_bar: ProgressBar = $HealthBar
@onready var tower_targeter: Area2D = %TowerTargeter
@onready var attack_timer: Timer = %AttackTimer

func _init() -> void:
	set_inspector_properties()

func _ready() -> void:
	enemy_type = GameC.EnemyType.ICE_SLIME
	initialize_enemy()
	health_bar.max_value = max_health
	health_bar.value = health
	
	attack_timer.timeout.connect(_on_attack_timer_timeout)

func _process(delta: float) -> void:
	health_bar.value = health
	if health == max_health:
		health_bar.visible = false
	else:
		health_bar.visible = true
	
	if is_dead or is_zapped:
		return
	
	progress_ratio += speed * delta / get_parent().curve.get_baked_length()
	if progress_ratio == 1.0:
		queue_free()
	
	# ----------------------------------
	# ---------- TOWER ATTACK ----------
	# ----------------------------------
	
	if not attack_ready:
		return
	
	var targets: Array[Node2D] = tower_targeter.get_overlapping_bodies()
	targets = targets.filter(
		func(target: Node2D) -> bool: return target.is_in_group("tower") and not target.is_iced
	)
	if not targets:
		return
	
	var closest_target: Node2D = get_closest_target(global_position, targets)
	var angle_to_target: float = get_angle_to_closest_target(closest_target)
	
	var new_ice_shard: IceShard = IceShard.create(angle_to_target)
	new_ice_shard.position = position - get_parent().global_position
	get_parent().add_child(new_ice_shard)
	
	attack_ready = false
	attack_timer.start()

func get_closest_target(pos: Vector2, targets: Array[Node2D]) -> Node2D:
	var min_distance: float = 9999
	var closest_target_index: int = -1
	for target_index in targets.size():
		var distance: float = pos.distance_to(targets[target_index].global_position)
		if distance < min_distance:
			min_distance = distance
			closest_target_index = target_index
	return targets[closest_target_index]

func get_angle_to_closest_target(closest_target: Node2D) -> float:
	var enemy_position: Vector2 = closest_target.global_position
	var angle_in_rads: float = global_position.angle_to_point(enemy_position)
	
	return angle_in_rads

func _on_attack_timer_timeout() -> void:
	attack_ready = true
