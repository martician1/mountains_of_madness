class_name DirectionComponent
extends Component

enum HorizontalDirection {
	LEFT,
	RIGHT
}
# The default horizontal direction of the collision shapes and sprites.
@export var default_horizontal_direction := HorizontalDirection.LEFT
@export var collision_flipper: HFlipper

var direction := Vector2(0,0):
	set(value):
		direction = value
		if direction.x > 0:
			collision_flipper.flip_h = (default_horizontal_direction == HorizontalDirection.LEFT)
		elif direction.x < 0:
			collision_flipper.flip_h = (default_horizontal_direction == HorizontalDirection.RIGHT)

func is_facing_left():
	var is_flipped = collision_flipper.flip_h
	return (is_flipped and default_horizontal_direction == HorizontalDirection.RIGHT) or \
		(not is_flipped and default_horizontal_direction == HorizontalDirection.LEFT)

func is_facing_right():
	return not is_facing_left()
