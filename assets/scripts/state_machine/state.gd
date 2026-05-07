class_name State
extends Node

func enter() -> void:
	pass
	
func exit() -> void:
	pass

func update(_delta: float) -> State:
	return self
	
func handle_input() -> State:
	return self
