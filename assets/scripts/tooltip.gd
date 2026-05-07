class_name Tooltip
extends Node2D

@export var text: String
var text_box_scene: PackedScene = preload("res://assets/scenes/ui/text_box.tscn")
var text_box: TextBox = null

func show_textbox():
	if text_box != null:
		return
	text_box = text_box_scene.instantiate()
	text_box.text = text
	add_child(text_box)
	text_box.position.y -= 10
	text_box.position.x += 0

func hide_textbox():
	if text_box == null:
		return
	remove_child(text_box)
	text_box.queue_free()
	text_box = null

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		show_textbox()

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == GameManager.player:
		hide_textbox()
