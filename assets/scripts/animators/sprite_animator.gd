class_name SpriteAnimator
extends BaseAnimator

@export var sprite: AnimatedSprite2D
@export var direction_component: DirectionComponent

func _process(_delta: float) -> void:
	if state_machine.current_state == null:
		return
	
	if direction_component:
		if direction_component.direction.x > 0:
			sprite.flip_h = (
				direction_component.default_horizontal_direction == \
				direction_component.HorizontalDirection.LEFT
			)
		elif direction_component.direction.x < 0:
			sprite.flip_h = (
				direction_component.default_horizontal_direction == \
				direction_component.HorizontalDirection.RIGHT
			)

	update()
