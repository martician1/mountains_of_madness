extends EnemyDyingState

func handle_input() -> State:
	var result = super.handle_input()
	if has_animation_finished:
		GameManager.level.level_finished.emit()
	return result
