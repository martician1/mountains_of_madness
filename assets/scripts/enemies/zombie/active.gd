extends State

@onready var zombie: Zombie = get_owner()
@onready var state_machine: ZombieStateMachine = %StateMachine
@onready var body_hitbox: Area2D = %BodyHitbox

@onready var alert_radius_component: EnemyAlertRadiusComponent = %AlertRadiusComponent
@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent
@onready var position_detection_component: EnemyPositionDetectionComponent = %PositionDetectionComponent

func update(delta: float) -> State:
	zombie.velocity.x = move_toward(zombie.velocity.x, 0.0, speed_component.speed)

	if GameManager.player.is_alive():
		direction_component.direct_towards_player()

		attack_component.attack_with_hitbox(body_hitbox)

		var is_in_alert_radius = alert_radius_component.is_player_in_alert_radius()
		var player_offset = GameManager.player.global_position - zombie.global_position

		if is_in_alert_radius and abs(player_offset.x) > 1.0:
			zombie.velocity.x = speed_component.speed * sign(direction_component.direction.x)

	if zombie.is_on_floor() and position_detection_component.is_near_dangerous_edge():
		zombie.velocity.x = 0

	if not zombie.is_on_floor():
		zombie.velocity += zombie.get_gravity() * delta

	zombie.move_and_slide()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt if health_component.health > 0 else %Dying
	return state_machine.decide_next_state()

func get_animation() -> String:
	return "idle" if zombie.velocity.x == 0 else "walk"
