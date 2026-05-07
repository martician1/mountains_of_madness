extends PlayerState

@onready var player: Player = get_owner()

func enter() -> void:
	player.velocity.x = 0

func update(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	player.move_and_slide()
	return self

func handle_input() -> State:
	if player.process_last_hit():
		return %Hurt
	
	if player.attack_cooldown_timer.time_left == 0:
		if Input.is_action_just_pressed("super_attack"):
			return %SuperAttack
		if Input.is_action_just_pressed("attack"):
			return %CrouchAttack

	if not Input.is_action_pressed("crouch"):
		return %Movement

	player.direction.x = Input.get_axis("strafe_left", "strafe_right")
	return self

func get_animation() -> String:
	return "crouch"
