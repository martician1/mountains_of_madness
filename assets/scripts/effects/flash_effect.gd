class_name FlashEffect
extends Node

@export var flash_time: float
@export var modulate_target: CanvasItem
var tween: Tween

func flash() -> void:
	modulate_target.modulate.a = 0.0
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(modulate_target, "modulate:a", 1.0, flash_time)
