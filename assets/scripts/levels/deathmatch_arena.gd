class_name DeathMatchArena
extends Node2D

@export var arena_width: float = 0.0

@onready var left_wall: StaticBody2D = $LeftWall
@onready var right_wall: StaticBody2D = $RightWall

@export var trigger_area: Area2D

@export var spawnwaves: Array[Spawnwave]
@export var level: Level
@export var camera_focus_time := 3.0

var enemies_left := 0
var current_wave_idx := 0
@onready var timer = %Timer

func _ready() -> void:
	if arena_width == 0.0:
		arena_width = get_viewport().get_visible_rect().size.x
	trigger_area.body_entered.connect(_on_body_entered, CONNECT_ONE_SHOT)
	place_walls()
	set_walls_enabled(false)

func spawn_wave() -> void:
	if current_wave_idx >= spawnwaves.size():
		level.level_finished.emit()
		return
	for spawn in spawnwaves[current_wave_idx].spawns:
		get_tree().create_timer(spawn.delay).timeout.connect(spawn_enemy.bind(spawn))
	enemies_left = spawnwaves[current_wave_idx].spawns.size()

	current_wave_idx += 1

func spawn_enemy(spawn: EnemySpawn) -> void:
	var enemy: Enemy = spawn.scene.instantiate()
	Util.get_component(enemy, "DieComponent").died.connect(_on_enemy_died)
	if spawn.variant:
		enemy.variant = spawn.variant
	add_child(enemy, true)
	enemy.global_position = (get_node(spawn.spawn) as Marker2D).global_position

func _on_enemy_died():
	enemies_left -= 1
	if enemies_left == 0:
		timer.start()

func place_walls() -> void:
	left_wall.position  = Vector2(-arena_width / 2.0, global_position.y)
	right_wall.position = Vector2(arena_width / 2.0, global_position.y)

func set_walls_enabled(enabled: bool) -> void:
	left_wall.get_node("CollisionShape2D").set_deferred("disabled", not enabled)
	right_wall.get_node("CollisionShape2D").set_deferred("disabled", not enabled)

func _on_body_entered(body: Node2D) -> void:
	set_walls_enabled(true)
	lock_camera()
	timer.start()
	trigger_area.queue_free()

func lock_camera() -> void:
	var cam := get_viewport().get_camera_2d()
	var half_w := arena_width / 2.0

	var final_left := int(global_position.x - half_w)
	var final_right := int(global_position.x + half_w)
	var final_bottom := global_position.y
	var final_top := global_position.y - get_viewport().get_visible_rect().size.y

	get_tree().create_tween().tween_property(cam, "limit_left", final_left, camera_focus_time)
	get_tree().create_tween().tween_property(cam, "limit_right", final_right, camera_focus_time)
	get_tree().create_tween().tween_property(cam, "limit_bottom", final_bottom, camera_focus_time)
	get_tree().create_tween().tween_property(cam, "limit_top", final_top, camera_focus_time)

func _on_timer_timeout() -> void:
	spawn_wave()
