class_name MainMenu
extends Control

@export var start_from_level_menu := false
@export var transition_time := 0.4

func _ready() -> void:
	%LevelMenu.visible = start_from_level_menu
	%StartMenu.visible = not start_from_level_menu

func _on_settings_button_button_up() -> void:
	print("Not implemented")

func _on_quit_button_button_up() -> void:
	get_tree().quit()

func _on_start_button_button_up() -> void:
	transition(%StartMenu, %LevelMenu)

func _on_back_button_button_up() -> void:
	transition(%LevelMenu, %StartMenu)

var is_transitioning := false

func transition(menu_1: Control, menu_2: Control):
	if is_transitioning:
		return
	is_transitioning = true
	await get_tree().create_tween().tween_property(menu_1, "modulate:a", 0.0, transition_time).finished
	menu_1.visible = false
	menu_2.visible = true
	menu_2.modulate.a = 0.0
	await get_tree().create_tween().tween_property(menu_2, "modulate:a", 1.0, transition_time).finished
	is_transitioning = false
