class_name HFlipper
extends Node2D

@export var flip_h := false:
	set(value):
		if value != flip_h:
			flip_h = value
			for child in get_children():
				var child2d = child as Node2D
				if child2d:
					child2d.scale.x *= -1.0
