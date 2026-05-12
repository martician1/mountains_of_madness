class_name BaseAnimator
extends AnimationPlayer

@export var state_machine : StateMachine
@export var call_reset_on_change: bool = true

func update(start_over_if_same: bool = false):
	var new_animation = state_machine.current_state.get_animation()
	if new_animation == "":
		return
	if (new_animation != current_animation or start_over_if_same) and call_reset_on_change: 
		play("RESET")
		advance(0)
	play(new_animation)
	if start_over_if_same:
		seek(0.0)
	advance(0)
