class_name EnemyRangedComponent
extends Component

@export var charge_velocity := 300
@export var shootpoint: Marker2D
@export var hell_charge_variant: HellChargeVariant

func shoot_hell_charge(direction: Vector2):
	var hell_charge: HellCharge = GameManager.level.hell_charge_scene.instantiate()
	hell_charge.variant = hell_charge_variant
	hell_charge.global_position = shootpoint.global_position
	hell_charge.velocity = charge_velocity * direction.normalized()
	GameManager.level.add_child(hell_charge)
