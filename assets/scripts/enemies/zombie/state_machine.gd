class_name ZombieStateMachine
extends StateMachine

@onready var zombie: Zombie = get_owner()
@onready var attack_hitbox: Area2D = %AttackHitbox
@onready var body_hitbox: Area2D = %BodyHitbox

# helper function used by many states to
# decide to which state to transition
func decide_next_state() -> State:
	var player := GameManager.player

	if player == null:
		return %Active

	if zombie.is_player_in_hitbox(attack_hitbox):
		return %Attack
	
	return %Active
