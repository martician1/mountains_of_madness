extends Enemy

@export var variant: SkullVariant

func _ready() -> void:
	%AnimatedSprite2D.sprite_frames = variant.sprite_frames
