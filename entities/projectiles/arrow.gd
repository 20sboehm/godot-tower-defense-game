class_name Arrow
extends Area2D

var speed: int = 300
var velocity: Vector2
var rot_in_rads: float
var pierce: int
var proj_range: float

@onready var lifetime_timer: Timer = $LifetimeTimer

static func create(angle_from_tower_in_rads: float, _pierce: int, _range: float) -> Arrow:
	var arrow: Arrow = load("res://entities/projectiles/arrow.tscn").instantiate()
	arrow.velocity = Vector2.RIGHT.rotated(angle_from_tower_in_rads)
	arrow.rot_in_rads = angle_from_tower_in_rads
	arrow.pierce = _pierce
	arrow.proj_range = _range
	return arrow

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	
	lifetime_timer.timeout.connect(_on_end_lifetime)
	var lifetime: float = proj_range / speed
	lifetime_timer.wait_time = lifetime + (lifetime * 0.1) # A little extra range for pierce
	lifetime_timer.start()

func _process(delta: float) -> void:
	rotation = rot_in_rads + (PI * 0.5)
	position += velocity * speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area.get_parent().is_dead == false and pierce > 0:
		pierce -= 1
		area.get_parent().take_damage(1)
		if pierce == 0:
			queue_free()

func _on_end_lifetime() -> void:
	queue_free()
