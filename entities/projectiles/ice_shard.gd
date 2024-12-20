class_name IceShard
extends Area2D

var speed: int = 200
var velocity: Vector2
var rot_in_rads: float
var exploded: bool = false

@onready var anim: AnimationPlayer = $AnimationPlayer

static func create(_angle: float) -> IceShard:
	var ice_shard: IceShard = load("res://entities/projectiles/scenes/ice_shard.tscn").instantiate()
	ice_shard.velocity = Vector2.RIGHT.rotated(_angle)
	ice_shard.rot_in_rads = _angle
	return ice_shard

func _ready() -> void:
	rotation = rot_in_rads + (PI * 0.5)
	body_entered.connect(_body_entered)

func _process(delta: float) -> void:
	if exploded:
		return
	
	position += velocity * speed * delta

func _body_entered(body: Node2D) -> void:
	if body.is_in_group("tower"):
		body.set_iced()
		exploded = true
		anim.play("die")

func die() -> void:
	queue_free()
