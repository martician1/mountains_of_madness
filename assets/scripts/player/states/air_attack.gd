class_name AirAttackState
extends PlayerOneShotAnimationState

# alternates between 1 and 2
var attack_version = 1

func exit():
	super.exit()
	player.attack_cooldown_timer.start()
	attack_version = 3 - attack_version
	animation_name = "air_attack_" + str(attack_version)

func update(delta: float) -> State:
	var result = super.update(delta)
	player.attack_enemies(player.melee_damage)
	return result
