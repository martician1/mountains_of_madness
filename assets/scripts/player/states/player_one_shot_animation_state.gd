class_name PlayerOneShotAnimationState
extends OneShotAnimationState

@onready var player: Player = get_owner()
@onready var state_machine: PlayerStateMachine = %StateMachine
@export var apply_physics: bool = true

func update(delta: float) -> State:
	if not apply_physics:
		return self

	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	player.move_and_slide()
	return self

func handle_input() -> State:
	if player.process_last_hit():
		return %Hurt
	if has_animation_finished:
		return next_state if next_state != null else state_machine.decide_next_state()
	return self
