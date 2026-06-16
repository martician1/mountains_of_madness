class_name FlyWave
extends Node

@export var track_count := 5
@export var spawn_interval := 6.0
@export var spawn_fluctuation := 3.0
@export var fly_parent_node: Node

class SpawnTrack extends Node:
	var y_offset_ratio: float
	var spawn_interval: float
	var spawn_fluctuation: float
	var fly_parent_node: Node
	var fly_scene = preload("res://assets/scenes/enemies/fly.tscn")

	func _init(_y_offset_ratio, _spawn_interval, _spawn_fluctuation, _fly_parent_node):
		y_offset_ratio = _y_offset_ratio
		spawn_interval = _spawn_interval
		spawn_fluctuation = _spawn_fluctuation
		fly_parent_node = _fly_parent_node

	func _ready():
		schedule_spawn()

	func schedule_spawn():
		get_tree().create_timer(
			spawn_interval + (randf() * 2 - 1) * spawn_fluctuation,
			false,
			true
		).timeout.connect(_on_spawn_timeout)

	func _on_spawn_timeout():
		var camera_center = get_viewport().get_camera_2d().get_screen_center_position()
		var visible_rect = get_viewport().get_visible_rect()
		
		var top_right = camera_center + Vector2(
			visible_rect.size.x / 2.0,
			-visible_rect.size.y / 2.0
		)
		var fly: Fly = fly_scene.instantiate()
		fly_parent_node.add_child(fly)
		fly.global_position = top_right + Vector2(0, y_offset_ratio * visible_rect.size.y)
		schedule_spawn()

func _ready() -> void:
	# Wait for player node to center the camera
	await get_tree().process_frame

	for i in range(track_count):
		add_child(
			SpawnTrack.new(
				float(i+1) / (track_count+1),
				spawn_interval,
				spawn_fluctuation,
				fly_parent_node
			)
		)
