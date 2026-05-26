extends PlayerOneShotAnimationState

func enter():
	super.enter()
	collision_animator.animation_finished.connect(
		_on_dead,
		CONNECT_ONE_SHOT
	)

func _on_dead(_name):
	await get_tree().create_timer(1.0).timeout
	GameManager.level.level_failed.emit()
