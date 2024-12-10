class_name Enemy
extends PathFollow2D

var enemy_type: GameConst.Enemy
var is_dead: bool = false
var is_zapped: bool = false
var health: int = 3
var speed: float = 0.07

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flash_timer: Timer = $FlashTimer
@onready var zap_timer: Timer = $ZapTimer

func _on_flash_timer_timeout() -> void:
	modulate = Color(1, 1, 1)

func _on_zap_timer_timeout() -> void:
	is_zapped = false
	modulate = Color(1, 1, 1)

func take_damage(damage: int) -> void:
	health -= damage
	modulate = Color(2, 2, 2)
	flash_timer.start()
	if health <= 0:
		animation_player.play("die")
		is_dead = true

func set_zapped(time: float) -> void:
	flash_timer.stop()
	health -= 1
	modulate = Color(2, 2, 2)
	is_zapped = true
	zap_timer.wait_time = time
	zap_timer.start()
	if health <= 0:
		animation_player.play("die")
		is_dead = true

func die() -> void:
	SignalBus.enemy_killed.emit(enemy_type)
	queue_free()
