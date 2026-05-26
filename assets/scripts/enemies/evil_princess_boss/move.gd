extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()
@onready var attack_component: EvilPrincessBossAttackComponent = %AttackComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var flash_effect: FlashEffect = %FlashEffect

var destination: Vector2
var speed: float
var next_state: State = null

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self
	
	direction_component.direct_towards_player()

	var offset: Vector2 = destination - evil_princess.global_position
	evil_princess.velocity = offset.normalized() * min(speed, offset.length() / delta)
	
	evil_princess.move_and_slide()
	attack_component.attack()
	
	return next_state if evil_princess.global_position.is_equal_approx(destination) else self

func handle_input():
	if hit_processing_component.process_last_hit(false):
		if health_component.health <= 0:
			return %Dying
		flash_effect.flash()
	return self

func get_animation() -> String:
	return "idle"
