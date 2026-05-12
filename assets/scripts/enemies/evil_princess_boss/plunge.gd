extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()

func enter() -> void:
	evil_princess.velocity.x = 0
	evil_princess.velocity.y = evil_princess.attack_speed

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self

	evil_princess.process_last_hit()
	evil_princess.move_and_slide()
	var collision: KinematicCollision2D = evil_princess.get_last_slide_collision()
	var has_collided_with_floor: bool = collision and is_equal_approx(collision.get_angle(), 0.0)
	evil_princess.try_hit_player()

	return %Attack if has_collided_with_floor else self

func get_animation() -> String:
	return "idle"
