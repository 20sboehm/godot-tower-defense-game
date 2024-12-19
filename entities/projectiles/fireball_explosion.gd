class_name FireballExplosion
extends Area2D

var level: int

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area.get_parent().is_dead == false:
		var dmg: int = GameC.t_data[GameC.TowerType.FIREBALL]["lvl_data"][level]["stats"]["damage"]
		area.get_parent().take_damage(dmg)

func destroy_self() -> void:
	queue_free()
