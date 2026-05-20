class_name EnemyHitProcessingComponent
extends HitProcessingComponent

func process_last_hit(register_knockback: bool = true) -> HitData:
	var last_hit = super.process_last_hit(register_knockback)
	if last_hit:
		GameManager.player.damage_dealt += last_hit.damage
	return last_hit
