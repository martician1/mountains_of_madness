class_name EnemyAttackComponent
extends Component

@export var damage := 1
@export var hitboxes : Array[Area2D]

func hit_player():
	var player_hit_processing_component: PlayerHitProcessingComponent = \
		Util.get_component(GameManager.player, "HitProcessingComponent")
	
	player_hit_processing_component.register_hit(
		HitData.new(owner, owner.global_position, damage)
	)

func attack() -> bool:
	var result := false
	for hitbox in hitboxes:
		result = attack_with_hitbox(hitbox) or result
	return result

func attack_with_hitbox(hitbox: Area2D) -> bool:
	if is_player_in_hitbox(hitbox):
		hit_player()
		return true
	return false

func is_player_in_hitbox(hitbox: Area2D) -> bool:
	if not GameManager.player.is_alive():
		return false

	for hurtbox in hitbox.get_overlapping_areas():
		if hurtbox.get_owner() == GameManager.player:
			return true

	return false
