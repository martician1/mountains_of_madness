class_name TextBox
extends Node2D

@onready var box: NinePatchRect = %NinePatchRect
@onready var margin_container: MarginContainer = %MarginContainer
@onready var label: Label = %Label

@export var text: String
@export var width := 64

func _ready() -> void:
	box.grow_vertical = Control.GROW_DIRECTION_BEGIN
	margin_container.custom_minimum_size.x = width
	set_text(text)

func set_text(text: String):
	label.text = text
	await get_tree().process_frame
	box.custom_minimum_size = margin_container.size
