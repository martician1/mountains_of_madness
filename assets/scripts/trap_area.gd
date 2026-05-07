extends Area2D

@export var animation_player: AnimationPlayer

@export var trapdoor_collision_shape: CollisionShape2D
@export var trap_area_collision_shape: CollisionShape2D

@export var trapdoor: Trapdoor

func _on_body_entered(body: Node2D) -> void:
	# Prevent reentering until the function completes 
	trap_area_collision_shape.set_deferred("disabled", true)	

	var scale: float
	scale = animation_player.get_animation("open").length / trapdoor.time_to_open
	animation_player.play("open", -1, scale)
	await animation_player.animation_finished
	
	trapdoor_collision_shape.set_deferred("disabled", true)
	
	await get_tree().create_timer(trapdoor.time_to_recover).timeout
	scale = animation_player.get_animation("close").length / trapdoor.time_to_close
	animation_player.play("close", -1, scale)
	await animation_player.animation_finished
	trapdoor_collision_shape.set_deferred("disabled", false)
	
	trap_area_collision_shape.set_deferred("disabled", false)
