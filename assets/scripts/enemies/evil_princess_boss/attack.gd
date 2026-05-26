extends OneShotAnimationState

@onready var evil_princess: EvilPrincessBoss = get_owner()

@onready var attack_component: EvilPrincessBossAttackComponent = %AttackComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var flash_effect: FlashEffect = %FlashEffect

func enter() -> void:
	super.enter()
	# Ascend to chase height
	%Move.destination = Vector2(evil_princess.global_position.x, evil_princess.chase_height)
	%Move.speed = attack_component.attack_speed
	%Move.next_state = %Chase

func exit():
	super.exit()
	attack_component.attack_finished.emit()

func update(delta: float) -> State:
	attack_component.attack()
	return self

func handle_input():
	if hit_processing_component.process_last_hit(false):
		if health_component.health <= 0:
			return %Dying
		flash_effect.flash()
	return super.handle_input()
