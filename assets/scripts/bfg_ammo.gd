extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		GameManager.bfg_ammo += 1
		queue_free()
