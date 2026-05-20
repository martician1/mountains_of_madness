extends Node

func get_component(node: Node, component_name: String) -> Component:
	var components_container = node.find_child("Components", false, false)
	if components_container == null:
		printerr("Node '%s' is missing a 'Components' child." % node.get_path())
		return null
	return components_container.find_child(component_name, false, false)
