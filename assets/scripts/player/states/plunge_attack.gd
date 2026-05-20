extends State

@onready var attack_component: PlayerAttackComponent = %AttackComponent
@onready var player: Player = get_owner()

func enter() -> void:
	player.velocity.x = 0
	player.velocity.y = player.plunge_speed

func update(_delta: float) -> State:
	attack_component.attack_targets(player.plunge_attack_damage)
	player.move_and_slide()
	if player.is_on_floor():
		return %Landing
	return self

func get_animation() -> String:
	return "plunge_attack"
