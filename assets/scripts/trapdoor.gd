extends StaticBody2D
class_name Trapdoor

@export var time_to_open: float
@export var time_to_recover: float
@export var time_to_close: float

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var trapdoor_collision_shape: CollisionShape2D = %TrapdoorCollisionShape2D
@onready var trap_area_collision_shape: CollisionShape2D = %TrapAreaCollisionShape2D

func _on_trap_area_body_entered(body: Node2D) -> void:
	# Prevent reentering until the function completes 
	trap_area_collision_shape.set_deferred("disabled", true)	

	var scale: float
	scale = animation_player.get_animation("open").length / time_to_open
	animation_player.play("open", -1, scale)
	await animation_player.animation_finished

	trapdoor_collision_shape.set_deferred("disabled", true)

	await get_tree().create_timer(time_to_recover).timeout
	scale = animation_player.get_animation("close").length / time_to_close
	animation_player.play("close", -1, scale)
	await animation_player.animation_finished
	trapdoor_collision_shape.set_deferred("disabled", false)

	trap_area_collision_shape.set_deferred("disabled", false)
