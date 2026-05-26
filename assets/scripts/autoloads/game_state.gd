extends Node

var highest_level: int = 1:
	set(val):
		highest_level = clamp(val, 1, 10)
const save_file_name = "savegame.save"
const save_file_path = "user://%s" % save_file_name

func save_progress():
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	save_file.store_8(highest_level)

func load_progress():
	if not FileAccess.file_exists(save_file_path):
		highest_level = 1
		return
	
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	if not save_file:
		var error = FileAccess.get_open_error()
		printerr("Failed to open save file %s, error code: %d" % [save_file_name, error])
		highest_level = 1
		return
	
	highest_level = save_file.get_8()

func _ready() -> void:
	load_progress()

func _exit_tree() -> void:
	save_progress()
