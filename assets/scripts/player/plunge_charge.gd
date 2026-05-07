extends OneShotAnimationState

func enter() -> void:
	super.enter()
	player.velocity = Vector2(0, 0)

func update(_delta: float) -> State:
	return self
