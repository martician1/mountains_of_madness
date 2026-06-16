extends State

@onready var imp: Imp = get_owner()
@onready var hitbox: Area2D = %Hitbox
@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var wakeup_component: EnemyWakeupComponent = %WakeupComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent

func update(_delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self
	
	if attack_component.attack():
		(%DieComponent as EnemyDieComponent).drop_pickup_component = null
		return %Dying

	if wakeup_component.is_awake:
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
