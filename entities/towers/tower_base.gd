class_name Tower
extends StaticBody2D

var lvl: int = 1 # Level
var attack_ready: bool = false:
	set(val):
		attack_ready = val
		if not val:
			atk_cooldown_progress = 0
var is_iced: bool = false
var tower_type: GameC.TowerType
var tower_range: float
var atk_cooldown: float # Attack cooldown
var atk_cooldown_progress: float = 0

@onready var enemy_targeter: Area2D = $EnemyTargeter
@onready var ice_timer: Timer = $IceTimer
@onready var collision_shape: CollisionShape2D = $EnemyTargeter/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var cooldown_indicator: TextureProgressBar = $TextureProgressBar

static func create(_tower_type: GameC.TowerType, pos: Vector2) -> Tower:
	var tower: Tower
	match (_tower_type):
		GameC.TowerType.ARCHER:
			tower = load("res://entities/towers/scenes/tower_archer.tscn").instantiate()
		GameC.TowerType.FIREBALL:
			tower = load("res://entities/towers/scenes/tower_fireball.tscn").instantiate()
		GameC.TowerType.ZAP:
			tower = load("res://entities/towers/scenes/tower_zap.tscn").instantiate()
		GameC.TowerType.BEAM:
			tower = load("res://entities/towers/scenes/tower_beam.tscn").instantiate()
	tower.position = pos
	return tower

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse"):
		SignalBus.click_tower.emit(self)

func initialize_tower() -> void:
	add_to_group("tower")
	#tower_range = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["atk_range"]
	#atk_cooldown = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["atk_cooldown"]
	collision_shape.shape.radius = tower_range
	input_pickable = true
	
	ice_timer.timeout.connect(_on_ice_timer_timeout)

func handle_attack_cooldown(delta: float) -> void:
	if attack_ready:
		return
	
	var progress_scalar: float = 0.5 if is_iced else 1.0
	
	if atk_cooldown_progress < atk_cooldown:
		atk_cooldown_progress += progress_scalar * delta
	else:
		attack_ready = true

func get_closest_target(pos: Vector2, targets: Array[Area2D]) -> Area2D:
	var min_distance: float = 9999
	var closest_target_index: int = -1
	for target_index in targets.size():
		var distance: float = pos.distance_to(targets[target_index].global_position)
		if distance < min_distance:
			min_distance = distance
			closest_target_index = target_index
	return targets[closest_target_index]

func get_angle_to_closest_target(closest_target: Area2D) -> float:
	var enemy_position: Vector2 = closest_target.global_position
	var angle_in_rads: float = enemy_targeter.global_position.angle_to_point(enemy_position)
	
	return angle_in_rads

func set_general_tower_level_data(_lvl: int) -> void:
	lvl = _lvl
	tower_range = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["atk_range"]
	atk_cooldown = GameC.t_data[tower_type]["lvl_data"][lvl]["stats"]["atk_cooldown"]
	collision_shape.shape.radius = tower_range
	sprite.frame = _lvl - 1
	if not attack_ready:
		atk_cooldown_progress = 0

func set_iced() -> void:
	if is_iced:
		return
	
	is_iced = true
	modulate = Color(1, 1.4, 1.4)
	cooldown_indicator.tint_progress = Color("#00ffff")
	ice_timer.start()

func _on_ice_timer_timeout() -> void:
	is_iced = false
	modulate = Color(1, 1, 1)
	cooldown_indicator.tint_progress = Color("#00c103")
