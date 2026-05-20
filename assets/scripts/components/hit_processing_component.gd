class_name HitProcessingComponent
extends Component

@export var shield_component: ShieldComponent = null
@export var health_component: HealthComponent = null
var last_hit: HitData

# If there is an active shield or no last hit this function returns null.
# In all other cases the function activates the shield if there is an shield component,
# applies damage, optionally applies knockback and moves out of last_hit and returns the HitData.
func process_last_hit(register_knockback: bool = true) -> HitData:
	if (shield_component and shield_component.is_shield_active()) or last_hit == null:
		return null

	if shield_component:
		shield_component.activate_shield()
	if health_component:
		health_component.health -= last_hit.damage
	if register_knockback:
		apply_knockback(
			last_hit.knockback,
			sign(owner.global_position.x - last_hit.from_position.x)
		)
	var result = last_hit
	last_hit = null

	return result

func register_hit(hit_data: HitData):
	call_deferred("_register_hit", hit_data)
	
func _register_hit(hit_data: HitData):
	if not shield_component or not shield_component.is_shield_active():
		last_hit = hit_data

func apply_knockback(knockback: Vector2, x_direction: float):
	owner.velocity.x += x_direction * knockback.x
	owner.velocity.y = -knockback.y
