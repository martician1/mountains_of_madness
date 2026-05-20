extends PlayerOneShotAnimationState

@onready var shield_component: ShieldComponent = %ShieldComponent
@onready var health_component: HealthComponent = %HealthComponent

func enter() -> void:
	super.enter()
	shield_component.activate_shield()

func handle_input() -> State:
	if not has_animation_finished:
		return self
	
	if health_component.health <= 0:
		return %Dying

	return state_machine.decide_next_state()
