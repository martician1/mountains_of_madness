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

	var shape := RectangleShape2D.new()
	shape.size = get_viewport().get_visible_rect().size

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, camera.get_screen_center_position())
	query.collision_mask = 1 << 26 # hurtbox
	query.collide_with_areas = true

	for hurtbox in get_world_2d().direct_space_state.intersect_shape(query).map(func(r): return r["collider"]):
		var enemy = hurtbox.owner as Enemy
		if enemy != null:
			enemy.register_hit(
				HitData.new(self, camera.get_screen_center_position(), damage, knockback)
			)

func _on_animated_sprite_2d_animation_finished() -> void:
	hit_enemies()
	super_attack_finished.emit()
	queue_free()
