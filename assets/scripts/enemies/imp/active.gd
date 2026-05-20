extends State

@onready var imp: Imp = get_owner()
@onready var hitbox: Area2D = %Hitbox
@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var alert_radius_comopnent: EnemyAlertRadiusComponent = %AlertRadiusComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent

func update(_delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self
	
	if attack_component.attack():
		return %Dying
	
	if alert_radius_comopnent.is_player_in_alert_radius():
		direction_component.direct_towards_player()
		imp.velocity = speed_component.speed * direction_component.direction
		imp.move_and_slide()

	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Dying
	return self

func get_animation() -> String:
	return "idle"
