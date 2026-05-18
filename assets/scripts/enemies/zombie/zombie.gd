class_name Zombie
extends Enemy

@export var alert_radius := 400.0
@export var max_drop := 64.0

func direct_towards_player():
	var player = GameManager.player

	if not player.is_alive():
		return

	var player_dir = player.global_position - global_position
	if player_dir.length() <= alert_radius and abs(player_dir.x) > 1.0:
		direction.x = sign(player_dir.x)
		velocity.x = speed * direction.x
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
