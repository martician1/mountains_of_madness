extends Level

@export var boss_attacks_between_spawnwaves := 3
@onready var spawn_markers := %Spawns.get_children()
@onready var fodder_spawn_cooldown := %FodderSpawnCooldown
@onready var evil_princess: EvilPrincessBoss = %EvilPrincessBoss
var zombies_left: int = 0

var fodder_enemy_scenes: Array[PackedScene] = [
	preload("res://assets/scenes/enemies/zombie.tscn"),
	#preload("res://assets/scenes/enemies/evil_eye.tscn"),
	#preload("res://assets/scenes/enemies/skull.tscn")
]

func _ready() -> void:
	evil_princess.attack_finished.connect(_on_boss_attack_finished)

func _on_boss_attack_finished():
	if zombies_left == 0 and fodder_spawn_cooldown.is_stopped():
		spawn_fodder_enemies()

func spawn_fodder_enemies():
	zombies_left = spawn_markers.size()
	for marker in spawn_markers:
		var enemy: Enemy = fodder_enemy_scenes[randi() % 1].instantiate()
		enemy.died.connect(_on_enemy_died)
		add_child(enemy, true)
		enemy.global_position = marker.global_position

func _on_enemy_died():
	zombies_left -= 1
	if zombies_left == 0:
		fodder_spawn_cooldown.start()
