class_name PlayerHitProcessingComponent
extends HitProcessingComponent

func process_last_hit(register_knockback: bool = false) -> HitData:
	var last_hit = super.process_last_hit(register_knockback)
	if last_hit:
		GameManager.player.damage_received += last_hit.damage
	return last_hit
