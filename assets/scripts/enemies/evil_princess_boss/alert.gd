extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self

	#evil_princess.process_last_hit()
	evil_princess.update_direction()
	evil_princess.try_hit_player()

	return %Plunge if owner.can_attack_player() else self

func get_animation() -> String:
	return "idle"
