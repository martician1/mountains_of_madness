class_name PlayerAttackComponent
extends Component

@export var knockback := Vector2(500.0, 100.0)
@export var hitboxes: Array[Area2D]
@onready var player: Player = get_owner()

func attack_targets(damage: int, apply_knockback: bool = false) -> void:
	for hitbox in hitboxes:
		for hurtbox in hitbox.get_overlapping_areas():
			var target_hit_processing_component: HitProcessingComponent = \
				Util.get_component(hurtbox.owner, "HitProcessingComponent")

			target_hit_processing_component.register_hit(
				HitData.new(
					player,
					player.global_position,
					damage,
					knockback if apply_knockback else Vector2.ZERO
				)
			)
