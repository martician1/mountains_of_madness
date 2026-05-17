extends OneShotAnimationState

@onready var evil_princess: EvilPrincessBoss = get_owner()
@onready var state_machine: StateMachine = %StateMachine

func enter() -> void:
	super.enter()
	# Ascend to chase height
	%Move.destination = Vector2(evil_princess.global_position.x, evil_princess.chase_height)
	%Move.speed = evil_princess.attack_speed
	%Move.next_state = %Chase

func exit():
	super.exit()
	evil_princess.attack_finished.emit()

func update(delta: float) -> State:
	evil_princess.process_last_hit()
	evil_princess.try_hit_player()
	return self
