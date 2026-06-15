extends State

@onready var fly: Fly = get_owner()
@onready var hitbox: Area2D = %Hitbox
@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var direction_component: EnemyDirectionComponent = %DirectionComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent
@onready var sprite: AnimatedSprite2D = %AnimatedSprite2D
@onready var visible_on_screen_notifier: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D

func enter():
	fly.velocity.x = -speed_component.speed

func update(_delta: float) -> State:
	var top_left_x = get_viewport().get_camera_2d().get_screen_center_position().x \
		- get_viewport().get_visible_rect().size.x / 2.0

	if not visible_on_screen_notifier.is_on_screen() and top_left_x >= fly.position.x:
		fly.queue_free()
		return self

	if attack_component.attack():
		return %Dying

	fly.move_and_slide()

	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Dying
	return self

func get_animation() -> String:
	return "idle"
