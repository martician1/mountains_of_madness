extends PlayerOneShotAnimationState

func enter():
	super.enter()
	collision_animator.animation_finished.connect(
		func (_name): GameManager.fail_level(),
		CONNECT_ONE_SHOT
	)
