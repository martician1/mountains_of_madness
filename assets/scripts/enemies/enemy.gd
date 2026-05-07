class_name Enemy
extends CharacterBody2D

var last_hit: HitData

@export var mana_ball_despawn_time := 4.0
@export var mana_ball_fadeout_time := 1.0

@export var damage: int
@export var health := 1:
	set(value):
		health = max(value, 0)
@export var speed := 100.0

var direction := Vector2(0,0)

var hell_charge_scene: PackedScene = preload("res://assets/scenes/hell_charge.tscn")
var mana_ball_scene: PackedScene = preload("res://assets/scenes/mana_ball.tscn")

@export var shield_cooldown_time := 0.2
var is_shield_active := false

func shoot_hell_charge(initial_position: Vector2, velocity: Vector2):
	var hell_charge: HellCharge = hell_charge_scene.instantiate()
	hell_charge.global_position = initial_position
	hell_charge.velocity = velocity
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
	var mana_ball: ManaBall = mana_ball_scene.instantiate()
	var spawnpoint := self.find_child("ManaBallSpawnpoint") as Marker2D
	var spawn_position := spawnpoint.global_position if spawnpoint != null else self.global_position
	mana_ball.global_position = spawn_position
	mana_ball.despawn_time = mana_ball_despawn_time
	mana_ball.fadeout_time = mana_ball_fadeout_time
	GameManager.level.add_child(mana_ball)
	GameManager.player.enemies_killed += 1
	queue_free()

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

func take_last_hit() -> HitData:
	if not is_shield_active and last_hit != null:
		activate_shield()
		var result = last_hit
		last_hit = null
		return result
	return null

func process_last_hit() -> bool:
	var last_hit = take_last_hit()
	if last_hit != null:
		health -= last_hit.damage
		GameManager.player.damage_dealt += last_hit.damage
		apply_knockback(last_hit.knockback, sign(global_position.x - last_hit.from_position.x))
		return true
	return false

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
	return space_state.intersect_ray(query).get("collider")

func is_near_dangerous_edge(min_edge_distance: float = 20.0, dangerous_depth: float = 64.0) -> bool:
	var in_front = global_position
	in_front.x += min_edge_distance * self.direction.x
	return get_ground(global_position, dangerous_depth) != get_ground(in_front, dangerous_depth)
