class_name CooldownComponent
extends Component

@export var cooldown_time : float = 1.0
@onready var timer: SceneTreeTimer

func is_cooldown_active() -> bool:
	return timer != null and timer.time_left != 0.0

func start_cooldown() -> void:
	timer = get_tree().create_timer(cooldown_time, false, true)
