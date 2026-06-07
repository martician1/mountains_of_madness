extends State

@onready var elemental: Elemental = get_owner()
@onready var state_machine: ElementalStateMachine = %StateMachine
@onready var body_hitbox: Area2D = %BodyHitbox

@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var gravity_component: GravityComponent = %GravityComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var jump_speed_component: EnemySpeedComponent = %JumpSpeedComponent
@onready var jump_cooldown_component: CooldownComponent = %JumpCooldownComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent
@onready var wakeup_component: EnemyWakeupComponent = %WakeupComponent

func update(delta: float) -> State:
	elemental.velocity.x = move_toward(elemental.velocity.x, 0.0, speed_component.speed)

	if GameManager.player.is_alive():
		direction_component.direct_towards_player()

		attack_component.attack_with_hitbox(body_hitbox)

		var player_offset = GameManager.player.global_position - elemental.global_position

		if wakeup_component.is_awake and abs(player_offset.x) > 1.0:
			elemental.velocity.x = speed_component.speed * sign(direction_component.direction.x)
		
		if elemental.is_on_floor() and wakeup_component.is_awake and not jump_cooldown_component.is_cooldown_active():
			elemental.velocity.y -= jump_speed_component.speed

	if not elemental.is_on_floor():
		elemental.velocity += gravity_component.get_gravity() * delta
	
	var was_on_floor = elemental.is_on_floor()
	elemental.move_and_slide()
	if not was_on_floor and elemental.is_on_floor():
		jump_cooldown_component.start_cooldown()
	if elemental.is_on_wall():
		elemental.velocity.x = 0
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt if health_component.health > 0 else %Dying
	return state_machine.decide_next_state()

func get_animation() -> String:
	return "idle" if is_zero_approx(elemental.velocity.x) else "walk"
