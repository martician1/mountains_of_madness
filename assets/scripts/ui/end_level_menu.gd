class_name EndLevelMenu
extends CanvasLayer

@export var enemies_killed: int
@export var damage_ratio: Variant
@export var time_in_seconds: int
@export var background_fade_in_time: float = 1.0

func _ready() -> void:
	%EnemiesKilled.text = str(enemies_killed)
	%DamageRatio.text = str(damage_ratio)
	@warning_ignore("integer_division")
	%TimeTaken.text = "%02d:%02d" % [time_in_seconds / 60, time_in_seconds % 60]
	await get_tree().create_tween().tween_property(%Background, "color:a", 1.0, background_fade_in_time).finished
	
	if not is_instance_valid(self) or is_queued_for_deletion():
		return
	
	GameManager.change_player(null)
	GameManager.change_level(null)
	var gameplay_scene = get_tree().current_scene
	assert(gameplay_scene is Gameplay)
	get_tree().current_scene = self
	get_tree().root.remove_child(gameplay_scene)
	gameplay_scene.queue_free()

func _on_button_button_up() -> void:
	GameManager.quit_level()
	queue_free()
