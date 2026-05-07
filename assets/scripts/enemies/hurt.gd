class_name EnemyHurtState
extends State

@export var collision_animator: CollisionAnimator
@export var sprite_animator: EnemySpriteAnimator
@export var next_state: State
var has_recovered := false

func enter() -> void:
	has_recovered = false
	collision_animator.update()
	collision_animator.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	collision_animator.animation_finished.disconnect(_on_animation_finished)

func _on_animation_finished(animation_name: String):
	assert(animation_name == "hurt")
	has_recovered = true

func update(delta: float) -> State:
	owner.velocity.x = move_toward(owner.velocity.x, 0, owner.speed)

	if not owner.is_on_floor():
		owner.velocity += owner.get_gravity() * delta
	
	owner.move_and_slide()
	return self

func handle_input() -> State:
	if owner.process_last_hit():
		has_recovered = false
		collision_animator.update(true)
		sprite_animator.update(true)
		return %Hurt if owner.health > 0 else %Dying
	return next_state if has_recovered else self

func get_animation() -> String:
	if has_recovered:
		return ""
	return "hurt"
