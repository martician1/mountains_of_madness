extends State

@export var hitbox: Area2D
@export var attack_cooldown_timer: Timer
@export var shooting_point: Marker2D
@export var hell_charge_speed := 300.0

func update(delta: float) -> State:
	var player := GameManager.player

	if player == null or not player.is_alive():
		return self
	
	if owner.is_player_in_hitbox(hitbox):
		owner.hit_player()

	owner.direction.x = sign(player.global_position.x - owner.global_position.x)
	if attack_cooldown_timer.is_stopped():
		owner.shoot_hell_charge(
			shooting_point.global_position,
			Vector2(owner.direction.x, 0).normalized() * hell_charge_speed
		)
		attack_cooldown_timer.start()

	if not owner.is_on_floor():
		owner.velocity += owner.get_gravity() * delta
	
	owner.move_and_slide()
	return self

func handle_input() -> State:
	if owner.process_last_hit():
		return %Hurt if owner.health > 0 else %Dying
	return self

func get_animation() -> String:
	return "idle"
