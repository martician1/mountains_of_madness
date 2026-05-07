extends State

@onready var zombie: Zombie = get_owner()
@onready var state_machine: ZombieStateMachine = %StateMachine
@onready var body_hitbox: Area2D = %BodyHitbox

func update(delta: float) -> State:
	if zombie.is_player_in_hitbox(body_hitbox):
		zombie.hit_player()
	
	zombie.direct_towards_player()

	if zombie.is_on_floor() and zombie.is_near_dangerous_edge(20.0, zombie.max_drop):
		zombie.velocity.x = 0

	if not zombie.is_on_floor():
		zombie.velocity += zombie.get_gravity() * delta
	
	zombie.move_and_slide()
	return self

func handle_input() -> State:
	if zombie.process_last_hit():
		return %Hurt if zombie.health > 0 else %Dying
	return state_machine.decide_next_state()

func get_animation() -> String:
	return "idle" if zombie.velocity.x == 0 else "walk"
