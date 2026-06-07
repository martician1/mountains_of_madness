class_name EnemyWakeupComponent
extends Component

@onready var enemy: Enemy = get_owner()
@export var wakeup_radius := 1000.0
@export var sleep_radius := 1000.0
@onready var is_awake: bool = is_player_in_radius(wakeup_radius)

func _physics_process(_delta: float) -> void:
	if not is_awake and is_player_in_radius(wakeup_radius):
		is_awake = true
	elif is_awake and not is_player_in_radius(sleep_radius):
		is_awake = false

func is_player_in_radius(r: float) -> bool:
	var player_offset = GameManager.player.global_position - enemy.global_position
	return player_offset.length() <= r
