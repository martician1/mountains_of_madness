extends EnemyDyingState

func enter() -> void:
	await super.enter()
	GameManager.level.level_finished.emit()
