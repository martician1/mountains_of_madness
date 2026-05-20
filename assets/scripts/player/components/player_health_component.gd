class_name PlayerHealthComponent
extends HealthComponent

signal health_changed(old: int, new: int)
signal max_health_changed(old: int, new: int)

@export var max_health: int = 14:
	set(value):
		var old_max_health = max_health
		max_health = value
		max_health_changed.emit(old_max_health, max_health)

func set_health(value):
	var old_health = health
	health = clamp(value, 0, max_health)
	health_changed.emit(old_health, health)
