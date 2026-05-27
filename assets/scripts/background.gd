class_name Background
extends Node2D

@export var variant: BackgroundVariant:
	set(value):
		variant = value
		if is_node_ready():
			update()

func _ready() -> void:
	update()

func update():
	var background_layers = $Parallax2D.get_children()
	assert(
		variant.textures.size() == background_layers.size(),
		"BackgroundVariant resource contains %d textures, expected %d." % [variant.textures.size(), background_layers.size()]
	)
	for i in range(background_layers.size()):
		(background_layers[i] as Sprite2D).texture = variant.textures[i]
