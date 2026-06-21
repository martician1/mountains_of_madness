extends Node

signal player_changed(old: Player, new: Player)
signal level_changed(old: Level, new: Level)

var player: Player
var level: Level
var current_level_number: int
@export var level_fadeout_time := 1.0
var level_start_time: int
var level_finish_time: int

var gameplay_scene: PackedScene = preload("res://assets/scenes/gameplay.tscn")
var end_level_menu_scene: PackedScene = preload("res://assets/scenes/ui/end_level_menu.tscn")
var fail_level_menu_scene: PackedScene = preload("res://assets/scenes/ui/fail_level_menu.tscn")
var player_scene: PackedScene = preload("res://assets/scenes/player/player.tscn")

const level_dir = "res://assets/scenes/levels"

func change_player(new_player: Player):
	if new_player != null:
		add_child(new_player)

	var old_player := player
	player = new_player

	player_changed.emit(old_player, new_player)

	if old_player != null:
		remove_child(old_player)
		old_player.queue_free()

func change_level(new_level: Level):
	if new_level != null:
		add_child(new_level)
		new_level.level_finished.connect(_on_level_finished, CONNECT_ONE_SHOT)
		new_level.level_failed.connect(_on_level_failed, CONNECT_ONE_SHOT)

	var old_level = level
	level = new_level

	level_changed.emit(old_level, new_level)

	if old_level != null:
		remove_child(old_level)
		old_level.queue_free()

func load_level(n: int):
	var path = "%s/level_%d.tscn" % [level_dir, n]
	change_player(player_scene.instantiate())
	change_level(load(path).instantiate())
	current_level_number = n

	var camera = get_viewport().get_camera_2d()
	camera.limit_bottom = int(level.bottom_left.position.y)
	camera.limit_left = int(level.bottom_left.position.x)
	camera.limit_top = int(level.top_right.position.y)
	camera.limit_right = int(level.top_right.position.x)
	player.global_position = level.player_spawn.global_position

	var gameplay_node: Gameplay = gameplay_scene.instantiate()

	# I wanted to change the theme for the second half of the game
	# but I ended up not liking the light background variant so
	# levels 6-10 are set to use the dark variant for the time being 
	gameplay_node.background_variant = gameplay_node.BackgroundVariant.Dark \
		if n <= 5 else gameplay_node.BackgroundVariant.Dark
#		if n <= 5 else gameplay_node.BackgroundVariant.Light
	get_tree().change_scene_to_node(gameplay_node)

	level_start_time = int(Time.get_unix_time_from_system())

func reload_level():
	load_level(current_level_number)

func quit_gameplay(next_scene: Node = null):
	if next_scene == null:
		next_scene = load("res://assets/scenes/ui/menu.tscn").instantiate()
		next_scene.start_from_level_menu = true

	var gameplay_scene = get_tree().current_scene
	assert(gameplay_scene is Gameplay)
	assert(next_scene is not Gameplay)

	var parent = next_scene.get_parent()
	if parent:
		parent.remove_child(next_scene)

	get_tree().root.add_child(next_scene)
	get_tree().current_scene = next_scene
	get_tree().root.remove_child(gameplay_scene)
	gameplay_scene.queue_free()

	change_level(null)
	change_player(null)

func _on_level_failed():
	level.level_finished.disconnect(_on_level_finished)

	level_finish_time = int(Time.get_unix_time_from_system())
	var fail_level_menu: FailLevelMenu = fail_level_menu_scene.instantiate()

	fail_level_menu.enemies_killed = player.enemies_killed
	fail_level_menu.damage_ratio = player.damage_dealt / player.damage_received if player.damage_received else "Infinity"
	fail_level_menu.time_in_seconds = level_finish_time - level_start_time

	await get_tree().create_timer(level_fadeout_time).timeout
	get_tree().root.add_child(fail_level_menu)

func _on_level_finished():
	level.level_failed.disconnect(_on_level_failed)

	level_finish_time = int(Time.get_unix_time_from_system())

	GameState.highest_level = max(GameState.highest_level, current_level_number + 1)

	var end_level_menu: EndLevelMenu = end_level_menu_scene.instantiate()

	end_level_menu.enemies_killed = player.enemies_killed
	end_level_menu.damage_ratio = player.damage_dealt / player.damage_received if player.damage_received else "Infinity"
	end_level_menu.time_in_seconds = level_finish_time - level_start_time

	get_tree().root.add_child(end_level_menu)
