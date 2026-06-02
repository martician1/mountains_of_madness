extends State

@onready var player: Player = get_owner()
@onready var state_machine: PlayerStateMachine = %StateMachine
@onready var direction_component: DirectionComponent = %DirectionComponent
@onready var hit_processing_component: PlayerHitProcessingComponent = %HitProcessingComponent
@onready var attack_cooldown_component: CooldownComponent = %AttackCooldownComponent

func enter() -> void:
	player.velocity.x = 0

func update(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	player.move_and_slide()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt
	
	if not attack_cooldown_component.is_cooldown_active():
		if state_machine.consume_super_attack_input():
			return %SuperAttack
		if Input.is_action_just_pressed("attack"):
			return %CrouchAttack

	if not Input.is_action_pressed("crouch"):
		return %Movement

	direction_component.direction.x = Input.get_axis("strafe_left", "strafe_right")
	return self

func get_animation() -> String:
	return "crouch"
