extends EnemyDyingState

func handle_input() -> State:
	var result = super.handle_input()
	if has_animation_finished:
		get_tree().create_timer(1.0).timeout.connect(func (): GameManager.level.level_finished.emit())
	return result
