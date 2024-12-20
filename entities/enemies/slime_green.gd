extends SlimeBase

func _init() -> void:
	set_inspector_properties()

func _ready() -> void:
	enemy_type = GameC.EnemyType.GREEN_SLIME
	initialize_enemy()
	
func _process(delta: float) -> void:
	if is_dead or is_zapped:
		return
	
	progress_ratio += speed * delta / get_parent().curve.get_baked_length()
	if progress_ratio == 1.0:
		queue_free()
