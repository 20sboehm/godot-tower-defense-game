extends Node2D

signal wave_over

var last_path: int = -1
@export var game_state: GameStateResource

@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_path_1: Path2D = %EnemyPath
@onready var enemy_path_2: Path2D = %EnemyPath2
@onready var enemy_path_3: Path2D = %EnemyPath3

func _on_timer_timeout() -> void:
	var enemies_to_spawn: Dictionary = GameConst.wave_data[game_state.wave]
	for enemy_type: int in enemies_to_spawn:
		if enemies_to_spawn[enemy_type] > 0:
			spawn_enemy(enemy_type)
			enemies_to_spawn[enemy_type] -= 1
			return
	spawn_timer.stop()
	wave_over.emit()

func spawn_enemy(e_type: GameConst.Enemy) -> void:
	var path: Path2D = choose_path()
	
	path.add_child(GameConst.enemy_objects[e_type].instantiate())

func choose_path() -> Path2D:
	var rng: RandomNumberGenerator = RandomNumberGenerator.new()
	
	var path_num: int = rng.randi_range(1, 3)
	while path_num == last_path:
		path_num = rng.randi_range(1, 3)
	
	last_path = path_num
	match (path_num):
		1:
			return enemy_path_1
		2:
			return enemy_path_2
		3:
			return enemy_path_3
		_:
			print("Something is wrong with path selection")
			return enemy_path_2

func start_wave() -> void:
	spawn_timer.start()
