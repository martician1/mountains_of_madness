class_name HellCharge
extends CharacterBody2D

@export var variant: HellChargeVariant
@export var damage := 1

func _ready() -> void:
	%AnimatedSprite2D.sprite_frames = variant.sprite_frames
	%AnimatedSprite2D.play("default")

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var body = collision.get_collider()
		if body == GameManager.player:
			var player_hit_processing_component: PlayerHitProcessingComponent = \
				Util.get_component(GameManager.player, "HitProcessingComponent")
			player_hit_processing_component.register_hit(
				HitData.new(self, global_position, damage, Vector2.ZERO)
			)
		queue_free()
