class_name Fireball
extends Area2D

var fireball_explosion: PackedScene = preload("res://entities/projectiles/fireball_explosion.tscn")

# Ensure the fireball doesn't spawn multiple explosions before it gets freed
var deactivated: bool = false

var speed: int = 150
var velocity: Vector2
var rot_in_rads: float
var proj_range: float
var level: int

@onready var lifetime_timer: Timer = $LifetimeTimer

static func create(angle_from_tower_in_rads: float, _range: float, _level) -> Fireball:
	var fireball: Fireball = load("res://entities/projectiles/fireball.tscn").instantiate()
	fireball.velocity = Vector2.RIGHT.rotated(angle_from_tower_in_rads)
	fireball.rot_in_rads = angle_from_tower_in_rads
	fireball.proj_range = _range
	fireball.level = _level
	return fireball

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	lifetime_timer.timeout.connect(_on_end_lifetime)
	var lifetime: float = proj_range / speed
	lifetime_timer.wait_time = lifetime + (lifetime * 0.2)
	lifetime_timer.start()

func _process(delta: float) -> void:
	rotation = rot_in_rads + (PI * 0.5)
	position += velocity * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area.get_parent().is_dead == false:
		if deactivated:
			return
		deactivated = true
		var explosion: FireballExplosion = fireball_explosion.instantiate()
		explosion.position = position
		explosion.level = level
		call_deferred("explode", explosion)

func explode(explosion: FireballExplosion) -> void:
	get_parent().add_child(explosion)
	queue_free()

func _on_end_lifetime() -> void:
	deactivated = true
	var explosion: FireballExplosion = fireball_explosion.instantiate()
	explosion.position = position
	explosion.level = level
	call_deferred("explode", explosion)
	queue_free()
