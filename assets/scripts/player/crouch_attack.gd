extends OneShotAnimationState

func exit() -> void:
	super.exit()
	player.attack_cooldown_timer.start()

func update(delta: float) -> State:
	player.attack_enemies(true)
	return super.update(delta)
