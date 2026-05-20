class_name EnemyDropPickupComponent
extends Component

@export var spawnpoint : Marker2D

class EnemyDrop:
	@export var despawn_time := 4.0
	@export var fadeout_time := 1.0
	@export var mana_probability := 0.9

func drop_pickup(drop: EnemyDrop = EnemyDrop.new()) -> void:
	var drop_node = GameManager.level.mana_ball_scene.instantiate() \
					if randf() < drop.mana_probability \
					else GameManager.level.health_drop_scene.instantiate()

	drop_node.global_position = spawnpoint.global_position
	drop_node.despawn_time = drop.despawn_time
	drop_node.fadeout_time = drop.fadeout_time
	GameManager.level.add_child(drop_node)
