extends Node2D
class_name JumpPad


# TODO: change area script to use gravity instead of impulse
@export var particles: GPUParticles2D

@export var impulse: float = 500.0
@export var particle_travel_distance: float = 100.0:
	set(value):
		(particles.process_material as ShaderMaterial).set_shader_parameter("USERDATA1", Vector4(particle_travel_distance, 0, 0, 0))
		particle_travel_distance = value
		update_particles()

func update_particles():
	var scale := particle_travel_distance / 100.0
	particles.amount = round(32 * scale)
	particles.lifetime = 4.0 * scale
