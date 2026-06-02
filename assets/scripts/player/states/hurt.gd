extends PlayerOneShotAnimationState

@onready var shield_cooldown_component: CooldownComponent = %ShieldCooldownComponent
@onready var health_component: HealthComponent = %HealthComponent

func enter() -> void:
	super.enter()
	shield_cooldown_component.start_cooldown()

func handle_input() -> State:
	if not has_animation_finished:
		return self
	
	if health_component.health <= 0:
		return %Dying

	return state_machine.decide_next_state()
