class_name EvilPrincessBossAttackComponent
extends EnemyAttackComponent

signal attack_finished()

@onready var evil_princess_boss: EvilPrincessBoss = get_owner()
@export var max_x_offset_for_attack := 5.0
@export var attack_speed := 200.0

func is_player_in_attack_area() -> bool:
	var player_x_offset = GameManager.player.global_position.x - \
		evil_princess_boss.global_position.x
	return abs(player_x_offset) <= max_x_offset_for_attack
