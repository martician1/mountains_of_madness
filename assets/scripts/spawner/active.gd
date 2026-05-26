extends State

@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var hit_processing_component: HitProcessingComponent = %HitProcessingComponent
@onready var flash_effect : FlashEffect = %FlashEffect
@onready var spawn_timer : Timer = %SpawnTimer

@export var enemy_scene_name : String = "res://assets/scenes/enemies/zombie.tscn"
@onready var enemy_scene: PackedScene = load(enemy_scene_name)

func spawn_enemy():
	var enemy_node = enemy_scene.instantiate()
	GameManager.level.add_child(enemy_node)
	enemy_node.global_position = owner.global_position

func update(_delta) -> State:
	if not GameManager.player.is_alive():
		return self

	attack_component.attack()
	if spawn_timer.is_stopped():
		spawn_enemy()
		spawn_timer.start()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit(false):
		if health_component.health <= 0:
			return %Dying
		flash_effect.flash()
	return self

func get_animation():
	return "idle"
