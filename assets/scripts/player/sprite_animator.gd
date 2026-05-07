class_name PlayerSpriteAnimator
extends AnimatedSprite2D

@onready var player: Player = get_owner()
@onready var state_machine : PlayerStateMachine = %StateMachine
@export var shield_flashes := 3

func _process(_delta: float) -> void:
	if state_machine.current_state == null:
		return
	
	if player.direction.x > 0:
		flip_h = false
	elif player.direction.x < 0:
		flip_h = true

	if player.shield_cooldown_timer.time_left != 0:
		modulate = Color("white", get_alpha())
	
	var next_animation = state_machine.current_state.get_animation()
	if next_animation != "":
		play(next_animation)

func get_alpha() -> float:
	var t = player.shield_cooldown_timer.wait_time - player.shield_cooldown_timer.time_left
	t /= player.shield_cooldown_timer.wait_time
	t = fmod(t * shield_flashes, 1.0)
	return cos(t * 2 * PI) / 2 + 0.5

func _on_shield_cooldown_timeout() -> void:
	modulate = Color("white", 1.0)
