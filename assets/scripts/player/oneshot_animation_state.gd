class_name OneShotAnimationState
extends PlayerState

@export var animation_name: String
@export var next_state: State = null

@onready var player: Player = get_owner()
@onready var animator: CollisionAnimator = %CollisionAnimator
@onready var state_machine: PlayerStateMachine = %StateMachine

var has_animation_finished := false

func enter() -> void:
	has_animation_finished = false
	animator.update()
	await animator.animation_finished
	has_animation_finished = true

func update(delta: float) -> State:
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	player.move_and_slide()
	return self

func handle_input() -> State:
	if has_animation_finished:
		return next_state if next_state != null else state_machine.decide_next_state()
	return self

func get_animation() -> String:
	if has_animation_finished:
		return ""
	return animation_name
