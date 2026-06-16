class_name Void
extends Area2D

var player_hit_processing_component: PlayerHitProcessingComponent
@export var fall_damage := 1
@export var tile_map_layer: TileMapLayer

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	set_physics_process(false)

	await get_tree().process_frame
	assert(GameManager.player != null)

	player_hit_processing_component = Util.get_component(
		GameManager.player,
		"HitProcessingComponent"
	)

	set_physics_process(true)

func _on_body_entered(body: Node2D):
	if body is Enemy:
		var state_machine = Util.get_state_machine(body)
		state_machine.scheduled_state = Util.get_state(state_machine, "Dying")
	if body is Player:
		var player = GameManager.player
		assert(body == player)

		player_hit_processing_component.register_hit(
			HitData.new(self, self.global_position, fall_damage)
		)

		# Try place on a tile
		var respawn_cell_coords = get_respawn_cell_coords(player.last_ground_position)
		if respawn_cell_coords == null:
			print(
				"No suitable respawn tile found for last_ground_position = ",
				player.last_ground_position
			)
			player.global_position = player.last_ground_position
			return

		player.global_position = tile_map_layer.to_global(
			tile_map_layer.map_to_local(respawn_cell_coords as Vector2i)
		)

# Given a position near_position returns the tilemap coordinates of a nearby cell
# where the player can respawn or null if no nearby cells are suitable.
func get_respawn_cell_coords(near_position: Vector2):
	var tile_size := tile_map_layer.tile_set.tile_size
	var respawn_point := near_position + \
		Vector2(-tile_size.x / 2.0, -tile_size.y / 2.0)
	var respawn_point_local_pos := tile_map_layer.to_local(respawn_point)
	var respawn_point_map_coords := tile_map_layer.local_to_map(respawn_point_local_pos)
	for i in range(2):
		for j in range(2):
			var respawn_candidate_cell_coords = respawn_point_map_coords + Vector2i(j, i)
			var respawn_candidate_cell = tile_map_layer.get_cell_tile_data(
				respawn_candidate_cell_coords
			)
			if respawn_candidate_cell:
				return respawn_candidate_cell_coords
	return null
