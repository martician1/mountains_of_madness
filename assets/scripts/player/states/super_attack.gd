extends State

@onready var player: Player = get_owner()
@onready var state_machine: PlayerStateMachine = %StateMachine
var has_super_attack_finished: bool

func enter() -> void:
	# TODO: preload super attacks
	var super_attack_node: SuperAttack = load(player.selected_super_attack.scene_path).instantiate()
	super_attack_node.super_attack_finished.connect(_on_super_attack_finished, CONNECT_ONE_SHOT)
	
	has_super_attack_finished = false
	GameManager.level.add_child(super_attack_node)

func exit():
	player.attack_cooldown_timer.start()

func update(delta: float):
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)

	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta

	player.move_and_slide()
	return self

func handle_input():
	if has_super_attack_finished:
		return state_machine.decide_next_state()
	return self

func _on_super_attack_finished():
	has_super_attack_finished = true

func get_animation():
	return "super_attack"
