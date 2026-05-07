extends Node

signal player_changed(old: Player, new: Player)
signal level_changed(old: Level, new: Level)

var player: Player
var level: Level
var level_path: String
@export var level_fadeout_time := 1.0
var level_start_time: int
var level_finish_time: int

var gameplay_scene: PackedScene = preload("res://assets/scenes/gameplay.tscn")
var end_level_menu_scene: PackedScene = preload("res://assets/scenes/ui/end_level_menu.tscn")
var player_scene: PackedScene = preload("res://assets/scenes/player/player.tscn")

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
		new_level.connect("level_finished", _on_level_finished, CONNECT_ONE_SHOT)

	var old_level = level
	level = new_level

	level_changed.emit(old_level, new_level)

	if old_level != null:
		remove_child(old_level)
		old_level.queue_free()


func load_level(path: String):
	change_level(load(path).instantiate())
	level_path = path
	change_player(player_scene.instantiate())

	get_tree().change_scene_to_node(gameplay_scene.instantiate())

	level_start_time = Time.get_unix_time_from_system()

func reload_level():
	load_level(level_path)

func quit_level():
	change_player(null)
	change_level(null)
	get_tree().change_scene_to_file("res://assets/scenes/ui/menu.tscn")

func _on_level_finished():
	level_finish_time = Time.get_unix_time_from_system()
	call_deferred("transition_to_end_level_menu")

func transition_to_end_level_menu():
	var end_level_menu: EndLevelMenu = end_level_menu_scene.instantiate()
	
	end_level_menu.enemies_killed = player.enemies_killed
	end_level_menu.damage_ratio = player.damage_dealt / player.damage_received if player.damage_received else "Infinity"
	end_level_menu.time_in_seconds = level_finish_time - level_start_time

	var canvas = CanvasLayer.new()
	canvas.add_child(end_level_menu)
	get_tree().root.add_child(canvas)
	
	await get_tree().create_tween().tween_property(
		end_level_menu,
		"color:a",
		1.0,
		level_fadeout_time
	).finished
	
	canvas.remove_child(end_level_menu)
	canvas.queue_free()

	change_player(null)
	change_level(null)
	
	# change scenes manually, the line bellow produces a flash
	# (the old scene is removed immediately while the new scene is assigned to current_scene at the end of next frame)
	# get_tree().change_scene_to_node(end_level_menu)
	get_tree().root.add_child(end_level_menu)
	var gameplay_scene = get_tree().current_scene
	get_tree().current_scene = end_level_menu
	get_tree().root.remove_child(gameplay_scene)
	gameplay_scene.queue_free()
