class_name EnemyPositionDetectionComponent
extends Component

@export_flags_2d_physics var collision_mask
@export var direction_component: EnemyDirectionComponent
@export var min_edge_distance := 20.0
@export var dangerous_depth := 64
@onready var enemy: Enemy = get_owner()

func get_ground(position: Vector2, penetration_depth: float) -> Object:
	var space_state := get_viewport().world_2d.direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		position,
		position + Vector2(0.0, penetration_depth),
		collision_mask
	)
	query.hit_from_inside = true
	return space_state.intersect_ray(query).get("collider")

func is_near_dangerous_edge(
	min_edge_distance: float = min_edge_distance,
	dangerous_depth: float = dangerous_depth
) -> bool:
	var in_front = enemy.global_position
	in_front.x += min_edge_distance * sign(direction_component.direction.x)
	return get_ground(in_front, dangerous_depth) == null
