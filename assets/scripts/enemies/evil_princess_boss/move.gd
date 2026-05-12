extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()

var destination: Vector2
var speed: float
var next_state: State = null

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self
	
	evil_princess.process_last_hit()
	evil_princess.update_direction()

	var offset: Vector2 = destination - evil_princess.global_position
	evil_princess.velocity = offset.normalized() * min(speed, offset.length() / delta)
	
	evil_princess.move_and_slide()
	evil_princess.try_hit_player()
	
	return next_state if evil_princess.global_position.is_equal_approx(destination) else self

func get_animation() -> String:
	return "idle"
