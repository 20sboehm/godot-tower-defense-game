class_name BeamTower
extends Tower

@onready var beam: Line2D = %Beam
@onready var disable_beam_delay: Timer = $DisableBeamDelay

func _ready() -> void:
	tower_type = GameC.TowerType.BEAM
	initialize_tower()
	set_tower_level(lvl)
	
	disable_beam_delay.timeout.connect(_disable_beam_delay)

func _process(delta: float) -> void:
	cooldown_indicator.value = atk_cooldown_progress / atk_cooldown
	handle_attack_cooldown(delta)
	
	#if not attack_ready:
		#return
	
	var targets: Array[Area2D] = enemy_targeter.get_overlapping_areas()
	targets = targets.filter(
		func(target: Area2D) -> bool: return target.is_in_group("enemy") and not target.get_parent().is_dead
	)
	if not targets:
		#beam.visible = false
		#beam.toggle_glow(false)
		if disable_beam_delay.is_stopped():
			disable_beam_delay.start()
		return
	
	disable_beam_delay.stop()
	
	var closest_target: Area2D = get_closest_target(enemy_targeter.global_position, targets)
	var angle_to_target: float = get_angle_to_closest_target(closest_target)
	
	var pos: Vector2 = closest_target.global_position - enemy_targeter.global_position
	var distance: float = enemy_targeter.global_position.distance_to(closest_target.global_position)
	beam.set_target_position_distance_and_angle(pos, distance, angle_to_target)
	beam.visible = true
	#beam.toggle_glow(true)
	#beam.toggle_emitting(true)
	
	if attack_ready:
		attack_ready = false
		closest_target.get_parent().take_damage(GameC.t_data[GameC.TowerType.BEAM]["lvl_data"][lvl]["stats"]["damage"])
		#disable_beam_delay.start()

func set_tower_level(_lvl: int) -> void:
	set_general_tower_level_data(_lvl)

func _disable_beam_delay() -> void:
	beam.visible = false
	#beam.toggle_glow(false)
	#beam.toggle_emitting(false)
