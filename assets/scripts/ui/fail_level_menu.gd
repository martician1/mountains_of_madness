class_name FailLevelMenu
extends CanvasLayer

@export var enemies_killed: int
@export var damage_ratio: Variant
@export var time_in_seconds: int
@export var background_fade_in_time: float = 1.0

func _ready() -> void:
	%EnemiesKilled.text = str(enemies_killed)
	%DamageRatio.text = str(damage_ratio)
	%TimeTaken.text = "%02d:%02d" % [time_in_seconds / 60, time_in_seconds % 60]

func _on_try_again_button_up() -> void:
	GameManager.reload_level()
	queue_free()

func _on_exit_button_up() -> void:
	GameManager.quit_gameplay()
	queue_free()
