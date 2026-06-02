class_name AirAttackState
extends PlayerOneShotAnimationState

@onready var attack_component: PlayerAttackComponent = %AttackComponent
@onready var attack_cooldown_component: CooldownComponent = %AttackCooldownComponent

# alternates between 1 and 2
var attack_version = 1

func exit():
	super.exit()
	attack_cooldown_component.start_cooldown()
	attack_version = 3 - attack_version
	animation_name = "air_attack_" + str(attack_version)

func update(delta: float) -> State:
	var result = super.update(delta)
	attack_component.attack_targets(player.melee_damage)
	return result
