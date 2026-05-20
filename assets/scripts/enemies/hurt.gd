class_name EnemyHurtState
extends OneShotAnimationState

@export var sprite_animator: SpriteAnimator
@export var speed_component: EnemySpeedComponent
@export var hit_processing_component: EnemyHitProcessingComponent
@export var health_component: HealthComponent

func _ready() -> void:
	animation_name = "hurt"

func update(delta: float) -> State:
	owner.velocity.x = move_toward(owner.velocity.x, 0, speed_component.speed)

	if not owner.is_on_floor():
		owner.velocity += owner.get_gravity() * delta
	
	owner.move_and_slide()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		has_animation_finished = false
		collision_animator.update(true)
		sprite_animator.update(true)
		return %Hurt if health_component.health > 0 else %Dying

	return next_state if has_animation_finished else self
