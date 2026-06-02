class_name ElementalStateMachine
extends StateMachine

@onready var attack_hitbox: Area2D = %AttackHitbox
@onready var attack_component: EnemyAttackComponent = %AttackComponent

# helper function used by many states to
# decide to which state to transition
func decide_next_state() -> State:
	if attack_component.is_player_in_hitbox(attack_hitbox):
		return %Attack
	return %Active
