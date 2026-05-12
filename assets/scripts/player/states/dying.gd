extends PlayerOneShotAnimationState

func enter() -> void:
	await super.enter()
	GameManager.fail_level()
