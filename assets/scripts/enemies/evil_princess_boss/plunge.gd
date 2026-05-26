extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()

@onready var attack_component: EvilPrincessBossAttackComponent = %AttackComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var flash_effect: FlashEffect = %FlashEffect

func enter() -> void:
	evil_princess.velocity.x = 0
	evil_princess.velocity.y = attack_component.attack_speed

func update(delta: float) -> State:
	var player := GameManager.player

	if not player.is_alive():
		return self

	evil_princess.move_and_slide()
	var collision: KinematicCollision2D = evil_princess.get_last_slide_collision()
	var has_collided_with_floor: bool = collision and is_equal_approx(collision.get_angle(), 0.0)
	attack_component.attack()

	return %Attack if has_collided_with_floor else self

func handle_input():
	if hit_processing_component.process_last_hit(false):
		if health_component.health <= 0:
			return %Dying
		flash_effect.flash()
	return self

func get_animation() -> String:
	return "idle"
