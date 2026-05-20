class_name ShieldComponent
extends Component

@export var shield_cooldown_time := 0.2
@onready var timer: SceneTreeTimer

func is_shield_active():
	return timer != null and timer.time_left != 0.0

func activate_shield():
	timer = get_tree().create_timer(shield_cooldown_time, false, true)
