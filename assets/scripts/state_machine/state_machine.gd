class_name StateMachine
extends Node

@export var initial_state: State

var current_state: State:
	set(new_state):
		if not is_node_ready():
			printerr("Ignoring enter() call on a state that's not ready.")
			return
		if new_state == current_state:
			return
		if current_state != null:
			current_state.exit()

		current_state = new_state

		if current_state != null:
			current_state.enter()

var scheduled_state: State = null

func _ready() -> void:
	current_state = initial_state

func _physics_process(delta: float) -> void:
	if scheduled_state != null:
		current_state = scheduled_state
		scheduled_state = null
	if current_state != null:
		current_state = current_state.handle_input()
		current_state = current_state.update(delta)
