extends Control

var pause_menu_scene = preload("res://assets/scenes/ui/pause_menu.tscn")

func _on_menu_button_button_up() -> void:
	add_child(pause_menu_scene.instantiate())
