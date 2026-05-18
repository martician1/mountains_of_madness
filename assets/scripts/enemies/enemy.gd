class_name Enemy
extends CharacterBody2D

signal died

var last_hit: HitData

@export var damage: int
@export var health := 1:
	set(value):
		health = max(value, 0)
@export var speed := 100.0

@export var collision_flipper: HFlipper

enum Direction {
	LEFT,
	RIGHT
}
@export var default_direction := Direction.LEFT

var direction := Vector2(0,0):
	set(value):
		direction = value
		if direction.x > 0:
			collision_flipper.flip_h = (default_direction == Direction.LEFT)
		elif direction.x < 0:
			collision_flipper.flip_h = (default_direction == Direction.RIGHT)

@export var shield_cooldown_time := 0.2
var is_shield_active := false

func update_direction():
	var player_x_offset = GameManager.player.global_position.x - global_position.x
	direction.x = sign(player_x_offset)

func shoot_hell_charge(initial_position: Vector2, charge_velocity: Vector2):
	var hell_charge: HellCharge = GameManager.level.hell_charge_scene.instantiate()
	hell_charge.global_position = initial_position
	hell_charge.velocity = charge_velocity
	GameManager.level.add_child(hell_charge)

func get_first_parent_in_group(group: String) -> Node:
	var node = self
	while node.get_parent() != null:
		node = node.get_parent()
		if node.is_in_group(group):
			return node
	return null

func get_descendants_in_group(parent: Node, group: String, result: Array[Node] = []) -> Array[Node]:
	for child in parent.get_children():
		if child.is_in_group(group):
			result.append(child)
		get_descendants_in_group(child, group, result)
	return result

func die():
	GameManager.player.enemies_killed += 1
	died.emit()
	queue_free()

class EnemyDrop:
	@export var despawn_time := 4.0
	@export var fadeout_time := 1.0
	@export var mana_probability := 0.9

func die_and_drop_pickup(drop: EnemyDrop = EnemyDrop.new()):
	var drop_node = GameManager.level.mana_ball_scene.instantiate() \
					if randf() < drop.mana_probability \
					else GameManager.level.health_drop_scene.instantiate()

	var spawnpoint := self.find_child("ManaBallSpawnpoint") as Marker2D
	var spawn_position := spawnpoint.global_position if spawnpoint != null else self.global_position
	drop_node.global_position = spawn_position
	drop_node.despawn_time = drop.despawn_time
	drop_node.fadeout_time = drop.fadeout_time
	GameManager.level.add_child(drop_node)
	die()

func hit_player():
	if GameManager.player != null:
		GameManager.player.register_hit(HitData.new(self, global_position, damage, Vector2.ZERO))

func is_player_in_hitbox(hitbox: Area2D) -> bool:
	var player = GameManager.player
	
	if player == null:
		return false

	for hurtbox in hitbox.get_overlapping_areas():
		if hurtbox.get_owner() == player:
			return true
	
	return false

func process_last_hit(register_knockback: bool = true) -> bool:
	if is_shield_active or last_hit == null:
		return false

	activate_shield()
	health -= last_hit.damage
	GameManager.player.damage_dealt += last_hit.damage
	if register_knockback:
		apply_knockback(last_hit.knockback, sign(global_position.x - last_hit.from_position.x))
	last_hit = null

	return true

func register_hit(hit_data: HitData):
	call_deferred("_register_hit", hit_data)
	
func _register_hit(hit_data: HitData):
	if not is_shield_active:
		last_hit = hit_data

func activate_shield():
	assert(not is_shield_active)
	is_shield_active = true
	get_tree().create_timer(shield_cooldown_time, false, true).timeout.connect(_on_shield_cooldown_elapsed)

func _on_shield_cooldown_elapsed():
	is_shield_active = false

func apply_knockback(knockback: Vector2, x_direction: float):
	velocity.x += x_direction * knockback.x
	velocity.y = -knockback.y

func get_ground(position: Vector2, penetration_depth: float) -> Object:
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		position,
		position + Vector2(0.0, penetration_depth),
		1 << 8 # mask ground, TODO: find a way to not hardcode this
	)
	query.hit_from_inside = true
	return space_state.intersect_ray(query).get("collider")

func is_near_dangerous_edge(min_edge_distance: float = 20.0, dangerous_depth: float = 64.0) -> bool:
	var in_front = global_position
	in_front.x += min_edge_distance * self.direction.x
	return get_ground(in_front, dangerous_depth) == null
	#return get_ground(global_position, dangerous_depth) != get_ground(in_front, dangerous_depth)
