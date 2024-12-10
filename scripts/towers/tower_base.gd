class_name Tower
extends StaticBody2D

var level: int = 1
var attack_ready: bool = true
var tower_type: GameConst.Tower
var tower_range: float

@onready var enemy_targeter: Area2D = $EnemyTargeter
@onready var attack_timer: Timer = $EnemyTargeter/AttackTimer
@onready var collision_shape: CollisionShape2D = $EnemyTargeter/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

static func create(_tower_type: GameConst.Tower, pos: Vector2) -> Tower:
	var tower: Tower
	match (_tower_type):
		GameConst.Tower.ARCHER:
			tower = load("res://scenes/towers/tower_archer.tscn").instantiate()
		GameConst.Tower.FIREBALL:
			tower = load("res://scenes/towers/tower_fireball.tscn").instantiate()
		GameConst.Tower.ZAP:
			tower = load("res://scenes/towers/tower_zap.tscn").instantiate()
	tower.tower_type = _tower_type
	tower.position = pos
	return tower

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_mouse"):
		SignalBus.click_tower.emit(self)

func initialize_tower() -> void:
	tower_range = GameConst.tower_level_data[tower_type][level]["attack_range"]
	collision_shape.shape.radius = tower_range
	input_pickable = true
	set_tower_level(level)

#func get_closest_target_index(targets: Array[Area2D]) -> int:
	#var min_distance: float = 9999
	#var closest_target_index: int = -1
	#for target_index in targets.size():
		#var distance: float = enemy_targeter.global_position.distance_to(targets[target_index].global_position)
		#if distance < min_distance:
			#min_distance = distance
			#closest_target_index = target_index
	#return closest_target_index

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

func set_tower_level(lvl: int) -> void:
	level = lvl
	attack_timer.wait_time = GameConst.tower_level_data[tower_type][level]["attack_rate"]
	tower_range = GameConst.tower_level_data[tower_type][level]["attack_range"]
	collision_shape.shape.radius = tower_range
	sprite.frame = lvl - 1

func _on_attack_timer_timeout() -> void:
	attack_ready = true
