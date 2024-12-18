class_name FireballExplosion
extends Area2D

var level: int

#var debug_dmg: int = 0
#var debug_exit: int = 0

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	#area_exited.connect(_on_area_exited)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy") and area.get_parent().is_dead == false:
		#print("dealing dmg!!")
		var dmg: int = GameC.t_data[GameC.TowerType.FIREBALL]["lvl_data"][level]["stats"]["damage"]
		#print(dmg)
		#area.get_parent().take_damage(1)
		area.get_parent().take_damage(dmg)

#func _on_area_exited(area: Area2D) -> void:
	#print("exited area")

# Used by animation player
#func toggle_collision(enabled: bool) -> void:
	#print("run run run!")
	#collision_shape_2d.disabled = not enabled

func destroy_self() -> void:
	print("DEATH\n\n")
	queue_free()
