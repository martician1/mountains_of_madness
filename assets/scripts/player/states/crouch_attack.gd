extends PlayerOneShotAnimationState

@onready var attack_component: PlayerAttackComponent = %AttackComponent
@onready var attack_cooldown_component: CooldownComponent = %AttackCooldownComponent

func exit() -> void:
	super.exit()
	attack_cooldown_component.start_cooldown()

func update(delta: float) -> State:
	var result = super.update(delta)
	attack_component.attack_targets(player.crouch_attack_damage, true)
	return result 
