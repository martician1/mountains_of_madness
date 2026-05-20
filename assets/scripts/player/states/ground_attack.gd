extends State
class_name GroundAttackState

@onready var player: Player = get_owner()
@onready var attack_component: PlayerAttackComponent = %AttackComponent
@onready var attack_cooldown_component: AttackCooldownComponent = %AttackCooldownComponent
@onready var hit_processing_component: PlayerHitProcessingComponent = %HitProcessingComponent

var combo = 0
enum QueuedAction {
	ATTACK,
	CROUCH
}
var action_queue : Array[QueuedAction] = []
@onready var collision_animator: CollisionAnimator = %CollisionAnimator
@onready var state_machine: PlayerStateMachine = %StateMachine
var has_current_attack_finished := false

func enter() -> void:
	player.velocity.x = 0

	action_queue.clear()
	combo = 0
	assert(player.max_ground_attack_combo > 0, "Invalid entry of attack state - player.max_attack_combo <= 0")
	start_attack()

func exit() -> void:
	if collision_animator.animation_finished.is_connected(_on_attack_finished):
		collision_animator.animation_finished.disconnect(_on_attack_finished)

	attack_cooldown_component.start_attack_cooldown()
	action_queue.clear()

func update(delta: float) -> State:
	attack_component.attack_targets(player.melee_damage, combo == player.max_ground_attack_combo)
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	player.move_and_slide()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt
	if Input.is_action_just_pressed("attack"):
		action_queue.append(QueuedAction.ATTACK)
	if Input.is_action_just_pressed("crouch"):
		action_queue.append(QueuedAction.CROUCH)
	
	if not has_current_attack_finished:
		return self
	
	# TODO: optimize this because it's O(n) for arrays
	var action = action_queue.pop_front()
	while action == QueuedAction.ATTACK:
		if combo < player.max_ground_attack_combo:
			start_attack()
			return self
		action = action_queue.pop_front()
	if action == QueuedAction.CROUCH:
		var next_action = action_queue[0] if action_queue.size() != 0 else null
		if next_action == QueuedAction.ATTACK:
			return %CrouchAttack

	return state_machine.decide_next_state()

func start_attack():
	has_current_attack_finished = false
	combo += 1
	collision_animator.update()
	collision_animator.animation_finished.connect(_on_attack_finished, CONNECT_ONE_SHOT)

func _on_attack_finished(_name: String):
	has_current_attack_finished = true

func get_animation() -> String:
	if has_current_attack_finished:
		return ""
	var attack_number = (combo - 1) % 3 + 1
	return "attack_" + str(attack_number)
