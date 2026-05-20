class_name AttackCooldownComponent
extends Component

@export var attack_cooldown_time := 0.2
var timer: SceneTreeTimer

func is_attack_cooldown_active():
	return timer != null and timer.time_left != 0.0

func start_attack_cooldown():
	timer = get_tree().create_timer(attack_cooldown_time, false, true)
