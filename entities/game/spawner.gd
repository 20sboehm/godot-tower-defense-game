extends Node2D

var last_path: int = -1
var phase: int = 0
var remaining_enemies: int = 0
var enemy_type: GameC.EnemyType

@onready var spawn_timer: Timer = $SpawnTimer
@onready var enemy_path_1: Path2D = %EnemyPath
@onready var enemy_path_2: Path2D = %EnemyPath2
@onready var enemy_path_3: Path2D = %EnemyPath3

func _ready() -> void:
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout() -> void:
	var wave_data: Array = GameC.level_wave_data[LevelState.level][LevelState.wave]
	var phase_data: Dictionary = wave_data[phase]
	
	if remaining_enemies == 0:
		remaining_enemies = phase_data["count"]
		enemy_type = phase_data["enemy_type"]
		spawn_timer.stop()
		spawn_timer.wait_time = phase_data["wait_time"]
		spawn_timer.start()
	
	spawn_enemy(enemy_type)
	
	remaining_enemies -= 1
	if remaining_enemies == 0:
		if phase + 1 < wave_data.size():
			phase += 1
		else:
			phase = 0
			spawn_timer.stop()
			#wave_over.emit()
			SignalBus.done_spawning.emit()

func spawn_enemy(e_type: GameC.EnemyType) -> void:
	var path: Path2D = choose_path()
	
	# Trying to store the slime object in GameC results in cyclic reference
	var slime: Enemy
	match (e_type):
		GameC.EnemyType.GREEN_SLIME:
			slime = load("res://entities/enemies/slime_green.tscn").instantiate()
		GameC.EnemyType.BLUE_SLIME:
			slime = load("res://entities/enemies/slime_blue.tscn").instantiate()
		GameC.EnemyType.TANK_SLIME:
			slime = load("res://entities/enemies/slime_tank.tscn").instantiate()
	path.add_child(slime)

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
			return enemy_path_2

func start_wave() -> void:
	spawn_timer.start()
