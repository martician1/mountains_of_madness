extends PlayerOneShotAnimationState

@onready var shield_cooldown_component: CooldownComponent = %ShieldCooldownComponent

func exit() -> void:
	super.exit()
	shield_cooldown_component.start_cooldown()
