class_name PulseEffect
extends Node

@export var oscillation_time := 1.0
@export var modulate_target: CanvasItem
@export var initial_alpha := 1.0
@export var target_alpha := 0.0
var tween: Tween

func play() -> void:
	if tween == null:
		modulate_target.modulate.a = initial_alpha
		tween = create_tween()
		tween.set_loops()
		tween.tween_property(modulate_target, "modulate:a", target_alpha, oscillation_time / 2.0)
		tween.tween_property(modulate_target, "modulate:a", initial_alpha, oscillation_time / 2.0)

func stop() -> void:
	if tween != null:
		tween.kill()
		tween = null
		modulate_target.modulate.a = initial_alpha
