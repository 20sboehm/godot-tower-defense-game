class_name FireballExplosion
extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area.get_parent().is_dead == false:
		area.get_parent().take_damage(1)

func toggle_collision(enabled: bool) -> void:
	collision_shape_2d.disabled = not enabled

func destroy_self() -> void:
	queue_free()
