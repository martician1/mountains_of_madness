extends OneShotAnimationState

func exit() -> void:
	super.exit()
	player.shield_cooldown_timer.start()
