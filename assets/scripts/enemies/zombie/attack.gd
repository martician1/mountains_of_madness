extends State

@onready var zombie: Zombie = get_owner()
@onready var animator: CollisionAnimator = %CollisionAnimator
@onready var sprite_animator: EnemySpriteAnimator = %SpriteAnimator
@onready var state_machine: StateMachine = %StateMachine
@onready var attack_hitbox: Area2D = %AttackHitbox

var has_current_attack_finished := false

func enter() -> void:
	has_current_attack_finished = false
	animator.update()
	await animator.animation_finished
	has_current_attack_finished = true

func update(delta: float) -> State:
	if zombie.is_player_in_hitbox(attack_hitbox):
		zombie.hit_player()
	
	if zombie.is_on_floor() and zombie.is_near_dangerous_edge(20.0, zombie.max_drop):
		zombie.velocity.x = 0
	else:
		zombie.velocity.x = move_toward(zombie.velocity.x, 0.0, zombie.speed)

	if not zombie.is_on_floor():
		zombie.velocity += zombie.get_gravity() * delta
	
	zombie.move_and_slide()
	return self

func handle_input() -> State:
	if zombie.process_last_hit():
		return %Hurt if zombie.health > 0 else %Dying
	if not has_current_attack_finished:
		return self
	var next_state = state_machine.decide_next_state()
	if next_state == self:
		self.enter()
	return next_state

func get_animation() -> String:
	return "" if has_current_attack_finished else "attack"
