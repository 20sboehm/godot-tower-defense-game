class_name Zap
extends Sprite2D

var curr_enemy_hitbox: Area2D
var zap_time: float = 0.5
var zap_range: float = 100

@onready var lifetime_timer: Timer = $LifetimeTimer

# Hex values for lightning: fcfa00, ddb200

static func create(target: Area2D, pos: Vector2, zap_distance: float, rot_in_rads: float) -> Zap:
	var zap: Zap = load("res://entities/projectiles/zap.tscn").instantiate()
	zap.curr_enemy_hitbox = target
	zap.position = pos
	zap.scale.x = zap_distance / 16
	zap.rotation = rot_in_rads
	zap.material.set_shader_parameter("sprite_width", zap_distance)
	return zap

func _ready() -> void:
	lifetime_timer.timeout.connect(_end_zap)
	lifetime_timer.wait_time = zap_time
	lifetime_timer.start()
	curr_enemy_hitbox.get_parent().set_zapped(zap_time)

func _end_zap() -> void:
	queue_free()
