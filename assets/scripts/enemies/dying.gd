class_name EnemyDyingState
extends State

@export var collision_animator: CollisionAnimator
@export var apply_physics := true
@export var visible_on_screen_enabler: VisibleOnScreenEnabler2D
var has_died := false

func enter() -> void:
	owner.remove_child(visible_on_screen_enabler)
	visible_on_screen_enabler.queue_free()

	has_died = false
	collision_animator.update()
	await collision_animator.animation_finished
	has_died = true
	owner.die()

func update(delta):
	if not apply_physics:
		return self

	owner.velocity.x = move_toward(owner.velocity.x, 0, owner.speed)

	if not owner.is_on_floor():
		owner.velocity += owner.get_gravity() * delta
	
	owner.move_and_slide()
	return self

func get_animation() -> String:
	if has_died:
		return ""
	return "die"
