extends OneShotAnimationState

func enter() -> void:
	if GameManager.level == null:
		printerr("Could not spawn super attack node - level not set")
		has_animation_finished = true
		return
	
	# TODO: preload super attacks
	var super_attack_node: SuperAttack = load(player.selected_super_attack.scene_path).instantiate()
	super_attack_node.super_attack_finished.connect(_on_super_attack_finished, CONNECT_ONE_SHOT)
	
	has_animation_finished = false
	GameManager.level.add_child(super_attack_node)
	
func _on_super_attack_finished():
	has_animation_finished = true

func exit():
	super.exit()
	player.attack_cooldown_timer.start()
