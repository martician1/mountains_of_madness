extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()
var attack_when_player_in_range : bool = true

func enter() -> void:
	evil_princess.velocity = Vector2.ZERO

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self

	evil_princess.process_last_hit()
	evil_princess.update_direction()

	var should_plunge: bool = attack_when_player_in_range and evil_princess.can_attack_player()

	if not should_plunge:
		evil_princess.velocity = evil_princess.speed * evil_princess.direction
		evil_princess.move_and_slide()

	evil_princess.try_hit_player()

	return %Plunge if should_plunge else self

func get_animation() -> String:
	return "idle"
