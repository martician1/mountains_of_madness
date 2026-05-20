class_name EnemyDirectionComponent
extends DirectionComponent

@onready var enemy: Enemy = get_owner()

func direct_towards_player():
	var player_offset = GameManager.player.global_position - enemy.global_position
	direction = player_offset.normalized()
