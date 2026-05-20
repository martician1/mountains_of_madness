class_name EnemyDyingState
extends OneShotAnimationState

@export var apply_physics := true
@export var visible_on_screen_enabler: VisibleOnScreenEnabler2D
@export var speed_component: EnemySpeedComponent
@export var die_component: EnemyDieComponent

func _ready() -> void:
	animation_name = "die"

func enter() -> void:
	owner.remove_child(visible_on_screen_enabler)
	visible_on_screen_enabler.queue_free()

	super.enter()

func update(delta):
	if not apply_physics:
		return self

	owner.velocity.x = move_toward(owner.velocity.x, 0, speed_component.speed)

	if not owner.is_on_floor():
		owner.velocity += owner.get_gravity() * delta
	
	owner.move_and_slide()
	return self

func handle_input() -> State:
	if has_animation_finished:
		die_component.die()
	return self
