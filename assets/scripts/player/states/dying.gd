extends PlayerOneShotAnimationState

func enter():
	super.enter()
	collision_animator.animation_finished.connect(
		func (_name): GameManager.level.level_failed.emit(),
		CONNECT_ONE_SHOT
	)
