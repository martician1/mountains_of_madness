extends PlayerOneShotAnimationState

func enter() -> void:
	super.enter()
	GameManager.fail_level()
