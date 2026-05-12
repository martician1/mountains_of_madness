class_name CollisionAnimator
extends BaseAnimator

func _physics_process(_delta: float) -> void:
	if state_machine.current_state != null:
		update()
