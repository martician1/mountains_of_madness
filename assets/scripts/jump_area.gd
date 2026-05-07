extends Area2D

@export var jump_pad: JumpPad

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.velocity.y = -jump_pad.impulse
