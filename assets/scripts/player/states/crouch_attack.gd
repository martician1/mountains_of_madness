extends PlayerOneShotAnimationState

func exit() -> void:
	super.exit()
	player.attack_cooldown_timer.start()

func update(delta: float) -> State:
	player.attack_enemies(player.crouch_attack_damage, true)
	return super.update(delta)
