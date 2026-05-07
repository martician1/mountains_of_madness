extends Area2D

@export var level: Level

func _on_body_entered(_body: Node2D) -> void:
	level.level_finished.emit()
