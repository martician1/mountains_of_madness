extends State

@export var attack_cooldown_component: AttackCooldownComponent
@export var attack_component: EnemyAttackComponent
@export var direction_component: EnemyDirectionComponent
@export var ranged_component: EnemyRangedComponent
@export var hit_processing_component: EnemyHitProcessingComponent
@export var health_component: HealthComponent

func update(delta: float) -> State:
	var player := GameManager.player

	if player.is_alive():
		attack_component.attack()
		direction_component.direct_towards_player()

		if not attack_cooldown_component.is_attack_cooldown_active():
			var charge_x_direction = -1 if direction_component.is_facing_left() else 1
			ranged_component.shoot_hell_charge(Vector2(charge_x_direction, 0))
			attack_cooldown_component.start_attack_cooldown()

	if not owner.is_on_floor():
		owner.velocity += owner.get_gravity() * delta
	
	owner.move_and_slide()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt if health_component.health > 0 else %Dying
	return self

func get_animation() -> String:
	return "idle"
