extends State

@onready var attack_component: EvilPrincessBossAttackComponent = %AttackComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent

func update(delta: float) -> State:
	direction_component.direct_towards_player()
	attack_component.attack()
	return %Plunge if attack_component.is_player_in_attack_area() else self

func get_animation() -> String:
	return "idle"
