class_name PlayerSpriteAnimator
extends SpriteAnimator

@onready var player: Player = get_owner()
@onready var shield_component: ShieldComponent = %ShieldComponent
@export var shield_flashes := 3

func _process(delta: float) -> void:
	if shield_component.is_shield_active():
		sprite.modulate.a = get_alpha()
	super._process(delta)

func get_alpha() -> float:
	var t = shield_component.shield_cooldown_time - shield_component.timer.time_left
	t /= shield_component.shield_cooldown_time
	t = fmod(t * shield_flashes, 1.0)
	return cos(t * 2 * PI) / 2 + 0.5

func _on_shield_cooldown_timeout() -> void:
	sprite.modulate.a = 1.0
