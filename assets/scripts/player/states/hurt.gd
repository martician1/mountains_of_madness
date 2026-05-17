extends PlayerOneShotAnimationState

func enter() -> void:
	super.enter()
	player.shield_cooldown_timer.start()

func handle_input() -> State:
	if not has_animation_finished:
		return self
	
	if player.health <= 0:
		return %Dying

	return state_machine.decide_next_state()
