extends OneShotAnimationState

@onready var visible_on_screen_enabler: VisibleOnScreenEnabler2D = %VisibleOnScreenEnabler2D

func enter() -> void:
	owner.remove_child(visible_on_screen_enabler)
	visible_on_screen_enabler.queue_free()

	super.enter()

func handle_input() -> State:
	if has_animation_finished:
		owner.queue_free()
	return self
