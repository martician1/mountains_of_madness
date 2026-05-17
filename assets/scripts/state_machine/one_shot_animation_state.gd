class_name OneShotAnimationState
extends State

@export var animation_name: String
@export var next_state: State = null
@export var collision_animator: CollisionAnimator
var has_animation_finished := false

func enter() -> void:
	has_animation_finished = false
	collision_animator.update()
	collision_animator.animation_finished.connect(_on_animation_finished)

func exit() -> void:
	collision_animator.animation_finished.disconnect(_on_animation_finished)

func _on_animation_finished(_name: String):
	has_animation_finished = true

func handle_input() -> State:
	if has_animation_finished:
		return next_state
	return self

func get_animation() -> String:
	if has_animation_finished:
		return ""
	return animation_name
