extends Enemy

func _ready() -> void:
	enemy_type = GameConst.Enemy.GREEN_SLIME
	health = 1
	speed = 0.06
	
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	zap_timer.timeout.connect(_on_zap_timer_timeout)

func _process(delta: float) -> void:
	if is_dead or is_zapped:
		return
	
	progress_ratio += speed * delta
	if progress_ratio == 1.0:
		queue_free()
