class_name EnemyAlertComponent
extends Component

@onready var enemy: Enemy = get_owner()
@export var alert_radius := 1000.0

func is_player_in_alert_radius():
	var player_offset = GameManager.player.global_position - enemy.global_position
	return player_offset.length() <= alert_radius
