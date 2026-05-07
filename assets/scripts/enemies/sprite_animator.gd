class_name EnemySpriteAnimator
extends AnimationPlayer

@export var state_machine : StateMachine
@export var sprite: AnimatedSprite2D
@export var call_reset_on_change: bool = false

enum Direction {
	LEFT,
	RIGHT
}
@export var default_direction := Direction.RIGHT

func _process(_delta: float) -> void:
	if state_machine.current_state == null:
		return
	
	if owner.direction.x > 0:
		sprite.flip_h = (default_direction == Direction.LEFT)
	elif owner.direction.x < 0:
		sprite.flip_h = (default_direction == Direction.RIGHT)

	update()

func update(start_over_if_same: bool = false):
	var new_animation = state_machine.current_state.get_animation()
	if new_animation == "":
		return
	if (new_animation != current_animation or start_over_if_same) and call_reset_on_change: 
		play("RESET")
		advance(0)
	play(new_animation)
	if start_over_if_same:
		seek(0.0)
	advance(0)
