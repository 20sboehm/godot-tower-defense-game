extends SlimeBase

@onready var health_bar: ProgressBar = $HealthBar

func _init() -> void:
	set_inspector_properties()

func _ready() -> void:
	enemy_type = GameC.EnemyType.SLIME_BOSS_ONE
	initialize_enemy()
	health_bar.max_value = max_health
	health_bar.value = health

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
