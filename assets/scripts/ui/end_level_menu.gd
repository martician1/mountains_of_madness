class_name EndLevelMenu
extends CanvasLayer

@export var enemies_killed: int
@export var damage_ratio: Variant
@export var time_in_seconds: int
@export var background_fade_in_time: float = 1.0

func _ready() -> void:
	%EnemiesKilled.text = str(enemies_killed)
	%DamageRatio.text = str(damage_ratio)
	%TimeTaken.text = "%02d:%02d" % [time_in_seconds / 60, time_in_seconds % 60]
	await get_tree().create_tween().tween_property(%Background, "color:a", 1.0, background_fade_in_time).finished
	
	if not is_instance_valid(self) or is_queued_for_deletion():
		return

	GameManager.quit_gameplay(self)

func _on_button_button_up() -> void:
	var main_menu_node: MainMenu = (load("res://assets/scenes/ui/menu.tscn") as PackedScene).instantiate()
	main_menu_node.start_from_level_menu = true
	get_tree().change_scene_to_node(main_menu_node)
	queue_free()
