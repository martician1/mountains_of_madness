extends State

@onready var player: Player = get_owner()
@onready var state_machine: PlayerStateMachine = %StateMachine
@onready var direction_component: DirectionComponent = %DirectionComponent
@onready var hit_processing_component: PlayerHitProcessingComponent = %HitProcessingComponent

var jump_combo = 0
var should_jump := false

func enter() -> void:
	jump_combo = 0 if player.is_on_floor() else player.max_jump_combo

func update(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	if should_jump:
		player.velocity.y = -player.jump_speed
		jump_combo += 1
		should_jump = false

	if direction_component.direction:
		player.velocity.x = direction_component.direction.x * player.speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, player.speed)

	player.move_and_slide()
	
	if player.is_on_floor():
		jump_combo = 0

	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt

	var next_state = state_machine.decide_next_state()
	if next_state != self:
		return next_state

	if Input.is_action_just_pressed("jump") and jump_combo < player.max_jump_combo:
		should_jump = true
	
	direction_component.direction.x = Input.get_axis("strafe_left", "strafe_right")
	return self

func get_animation():
	if player.is_on_floor():
		if direction_component.direction.x == 0:
			return "idle"
		else:
			return "walk"
	else:
		if player.velocity.y > 0:
			return "fall"
		else:
			return "jump"
