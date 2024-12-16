extends Enemy

func _ready() -> void:
	enemy_type = GameC.EnemyType.GREEN_SLIME
	initialize_enemy()
	
func _process(delta: float) -> void:
	if is_dead or is_zapped:
		return
	
	progress_ratio += speed * delta
	if progress_ratio == 1.0:
		queue_free()
