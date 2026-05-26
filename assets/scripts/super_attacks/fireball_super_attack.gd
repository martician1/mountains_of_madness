extends SuperAttack

@export var speed := 800.0
@export var player_y_offset := -30
@onready var hitbox: CollisionShape2D = %Hitbox

func _ready() -> void:
	var left_x = get_viewport().get_camera_2d().get_screen_center_position().x \
		- get_viewport().get_visible_rect().size.x / 2.0
	global_position.x = left_x
	global_position.y = GameManager.player.global_position.y + player_y_offset

func _process(delta: float) -> void:
	position.x += speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	super_attack_finished.emit()
	queue_free()

func _on_area_2d_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.owner != GameManager.player:
		Util.get_component(hurtbox.owner, "HitProcessingComponent").register_hit(
			HitData.new(self, hitbox.global_position, damage, knockback)
		)
