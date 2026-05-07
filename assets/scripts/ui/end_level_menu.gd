class_name EndLevelMenu
extends Control

@export var enemies_killed: int
@export var damage_ratio: Variant
@export var time_in_seconds: int

func _ready() -> void:
	%EnemiesKilled.text = str(enemies_killed)
	%DamageRatio.text = str(damage_ratio)
	@warning_ignore("integer_division")
	%TimeTaken.text = "%02d:%02d" % [time_in_seconds / 60, time_in_seconds % 60]


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://assets/scenes/ui/menu.tscn")
