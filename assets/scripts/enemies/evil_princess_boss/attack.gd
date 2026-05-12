extends State

@onready var evil_princess: EvilPrincessBoss = get_owner()
@onready var state_machine: StateMachine = %StateMachine
@onready var animator: CollisionAnimator = %CollisionAnimator

var has_animation_finished = false

func enter() -> void:
	has_animation_finished = false
	animator.update()
	await animator.animation_finished
	has_animation_finished = true
	# Ascend to chase height
	%Move.destination = Vector2(evil_princess.global_position.x, evil_princess.chase_height)
	%Move.speed = evil_princess.attack_speed
	%Move.next_state = %Chase

func exit():
	evil_princess.attack_finished.emit()

func update(delta: float) -> State:
	evil_princess.process_last_hit()
	evil_princess.try_hit_player()
	return self

func handle_input() -> State:
	return %Move if has_animation_finished else self

func get_animation() -> String:
	return "" if has_animation_finished else "attack"
