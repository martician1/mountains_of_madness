extends PlayerOneShotAnimationState

func exit() -> void:
	super.exit()
	player.shield_cooldown_timer.start()
