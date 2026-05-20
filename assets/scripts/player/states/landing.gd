extends PlayerOneShotAnimationState

@onready var shield_component: ShieldComponent = %ShieldComponent

func exit() -> void:
	super.exit()
	shield_component.activate_shield()
