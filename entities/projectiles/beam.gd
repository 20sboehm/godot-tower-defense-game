extends Line2D

@onready var start_particles: CPUParticles2D = $StartParticles
@onready var end_particles: CPUParticles2D = $EndParticles
#@onready var world_environment: WorldEnvironment = $WorldEnvironment

#func _ready() -> void:
	#points[0] = Vector2(0, 0)
	#start_particles.position = Vector2(0, 0)

#func toggle_glow(enabled: bool) -> void:
	#world_environment.environment.glow_enabled = enabled

#func toggle_emitting(enabled: bool) -> void:
	#start_particles.emitting = enabled
	#end_particles.emitting = enabled

func set_target_position_distance_and_angle(pos: Vector2, distance: float, angle: float) -> void:
	points[1] = Vector2(distance, 0)
	end_particles.position = Vector2(distance, 0)
	#end_particles.global_position = pos
	#end_particles.position = points[1]
	rotation = angle
	#end_particles.position = target
	#end_particles.rotation = angle + 1.5 * PI
	#rotation = angle
	#print(angle)

#func set_target_position_and_angle(target: Vector2, angle: float) -> void:
	#points[1] = target
	#end_particles.position = target
	#end_particles.rotation = angle + 1.5 * PI
	##rotation = angle
	#print(angle)

