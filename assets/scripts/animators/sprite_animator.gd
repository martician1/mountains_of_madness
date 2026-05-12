class_name SpriteAnimator
extends BaseAnimator

@export var sprite: AnimatedSprite2D

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
