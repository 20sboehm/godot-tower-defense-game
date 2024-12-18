class_name Enemy
extends PathFollow2D

var enemy_type: GameC.EnemyType
var is_dead: bool = false
var is_zapped: bool = false
var max_health: int
var health: int
var speed: float
var tower_damage: int

@onready var area: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flash_timer: Timer = $FlashTimer
@onready var zap_timer: Timer = $ZapTimer

func initialize_enemy() -> void:
	max_health = GameC.e_data[enemy_type]["hp"]
	health = max_health
	speed = GameC.e_data[enemy_type]["speed"]
	tower_damage = GameC.e_data[enemy_type]["tower_damage"]
	area.area_entered.connect(_on_area_entered)
	flash_timer.timeout.connect(_on_flash_timer_timeout)
	zap_timer.timeout.connect(_on_zap_timer_timeout)

func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		is_dead = true
		animation_player.play("die")
	modulate = Color(2, 2, 2)
	flash_timer.start()

func set_zapped(time: float) -> void:
	flash_timer.stop()
	health -= 1
	modulate = Color(2, 2, 2)
	is_zapped = true
	zap_timer.wait_time = time
	zap_timer.start()
	if health <= 0:
		is_dead = true
		animation_player.play("die")

func die() -> void:
	SignalBus.enemy_killed.emit(enemy_type)
	queue_free()

func _on_flash_timer_timeout() -> void:
	modulate = Color(1, 1, 1)

func _on_zap_timer_timeout() -> void:
	is_zapped = false
	modulate = Color(1, 1, 1)

func _on_area_entered(_area: Area2D) -> void:
	if _area.is_in_group("tree"):
		_area.take_damage(tower_damage)
		queue_free()
