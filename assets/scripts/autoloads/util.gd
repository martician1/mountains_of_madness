extends Node

func get_component(node: Node, component_name: String) -> Component:
	var components_container := get_components_container(node)
	if components_container == null:
		return null
	return components_container.find_child(component_name, false, false)

func remove_component(node: Node, component_name: String) -> bool:
	var components_container := get_components_container(node)
	if components_container == null:
		return false
	components_container.remove_child(
		components_container.find_child(component_name, false, false)
	)
	return true

func get_components_container(node: Node) -> Node:
	var components_container = node.find_child("Components", false, false)
	if components_container == null:
		printerr("Node '%s' is missing a 'Components' child." % node.get_path())
		return null
	return components_container

func get_state_machine(node: Node) -> StateMachine:
	var state_machine: StateMachine = node.find_child("StateMachine", false, false)
	if state_machine == null:
		printerr("Node '%s' is missing a 'StateMachine' child." % node.get_path())
		return null
	return state_machine

func get_state(state_machine: StateMachine, state_name: String) -> State:
	return state_machine.find_child(state_name, false, false)
