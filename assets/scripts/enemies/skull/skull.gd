extends Enemy

@export var variant: SkullVariant

func _ready() -> void:
	%AnimatedSprite2D.sprite_frames = variant.sprite_frames
	%RangedComponent.hell_charge_variant = variant.hell_charge_variant
