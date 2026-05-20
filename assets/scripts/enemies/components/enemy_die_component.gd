class_name EnemyDieComponent
extends Component

signal died()

@onready var enemy: Enemy = get_owner()
@export var drop_pickup_component: EnemyDropPickupComponent = null

func die():
	if drop_pickup_component != null:
		drop_pickup_component.drop_pickup()
	GameManager.player.enemies_killed += 1
	died.emit()
	enemy.queue_free()
