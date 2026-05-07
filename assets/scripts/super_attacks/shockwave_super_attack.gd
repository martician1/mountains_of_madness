extends SuperAttack

@onready var sprite_pivot := %SpritePivot

func _ready() -> void:
	get_viewport().size_changed.connect(_center_sprite)
	_center_sprite()

func _center_sprite() -> void:
	var viewport_rect = get_viewport_rect()
	sprite_pivot.position.x = viewport_rect.size.x / 2
	sprite_pivot.position.y = viewport_rect.size.y / 4

func hit_enemies() -> void:
	var camera := get_viewport().get_camera_2d()
	var rect := get_viewport().get_visible_rect()
	rect.position = camera.get_screen_center_position() - rect.size / 2.0

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if rect.has_point(enemy.global_position):
			enemy.register_hit(
				HitData.new(self, camera.get_screen_center_position(), damage, knockback)
			)

func _on_animated_sprite_2d_animation_finished() -> void:
	hit_enemies()
	super_attack_finished.emit()
	queue_free()
