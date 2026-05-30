extends Control

func _on_return_button_up() -> void:
	queue_free()

func _on_restart_button_up() -> void:
	GameManager.reload_level()

func _on_exit_button_up() -> void:
	GameManager.quit_gameplay()

func _ready() -> void:
	get_tree().paused = true

func _exit_tree() -> void:
	get_tree().paused = false
