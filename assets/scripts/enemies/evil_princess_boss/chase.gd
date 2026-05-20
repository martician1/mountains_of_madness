extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()
@onready var attack_component: EvilPrincessBossAttackComponent = %AttackComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent
@onready var flash_effect: FlashEffect = %FlashEffect

var attack_when_player_in_range : bool = true

func enter() -> void:
	evil_princess.velocity = Vector2.ZERO

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self

	direction_component.direct_towards_player()

	var should_plunge: bool = attack_when_player_in_range and attack_component.is_player_in_attack_area()

	if not should_plunge:
		evil_princess.velocity.x = speed_component.speed * sign(direction_component.direction.x)
		evil_princess.move_and_slide()

	attack_component.attack()

	return %Plunge if should_plunge else self

func handle_input():
	if hit_processing_component.process_last_hit():
		if health_component.health <= 0:
			return %Dying
		flash_effect.flash()
	return self

func get_animation() -> String:
	return "idle"
