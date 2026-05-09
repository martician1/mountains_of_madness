class_name Player
extends CharacterBody2D

signal health_changed(old: int, new: int)
signal max_health_changed(old: int, new: int)
signal mana_changed(old: int, new: int)
signal max_mana_changed(old: int, new: int)
signal selected_super_attack_changed(old: SuperAttackData, new: SuperAttackData)

@export var max_health: int = 3:
	set(value):
		var old_max_health = max_health
		max_health = value
		max_health_changed.emit(old_max_health, max_health)

@export var health: int = 3:
	set(value):
		var old_health = health
		health = clamp(value, 0, max_health)
		health_changed.emit(old_health, health)

@export var max_mana: int = 20:
	set(value):
		var old_max_mana = max_mana
		max_mana = value
		max_mana_changed.emit(old_max_mana, max_mana)

@export var mana: int = 3:
	set(value):
		var old_mana = mana
		mana = clamp(value, 0, max_mana)
		mana_changed.emit(old_mana, mana)

@export var speed = 120.0
@export var jump_speed = 360.0
@export var plunge_speed = 500.0

@export var max_jump_combo := 2
@export var max_ground_attack_combo := 3

@export var knockback := Vector2(500.0, 100.0)

@onready var collision_flipper: HFlipper = %CollisionFlipper

enum Direction {
	LEFT,
	RIGHT
}

@export var default_direction := Direction.RIGHT

var direction := Vector2(1,0):
	set(value):
		direction = value
		if direction.x > 0:
			collision_flipper.flip_h = (default_direction == Direction.LEFT)
		elif direction.x < 0:
			collision_flipper.flip_h = (default_direction == Direction.RIGHT)

@export var melee_damage := 1

@onready var state_machine: PlayerStateMachine = %StateMachine
@onready var hitbox: Area2D = %Hitbox
@onready var hurtbox: Area2D = %Hurtbox
@onready var attack_cooldown_timer: Timer = %AttackCooldown
@onready var shield_cooldown_timer: Timer = %ShieldCooldown
@onready var camera: Camera2D = $Camera2D

@export var super_attacks: Array[SuperAttackData]

var selected_super_attack_id: int = 0:
	set(value):
		var old_super_attack_id = selected_super_attack_id
		selected_super_attack_id = value

		selected_super_attack_changed.emit(
			super_attacks[selected_super_attack_id],
			super_attacks[old_super_attack_id]
		)

var selected_super_attack: SuperAttackData:
	set(_val):
		printerr("Invalid attempt to set derived property `selected_super_attack`, try setting `super_attacks` and `selected_super_attack_id` properties instead")
		return
	get():
		return super_attacks[selected_super_attack_id]

var last_hit: HitData
var is_burning := false
var enemies_killed := 0
var damage_received := 0
var damage_dealt := 0

func reset_stats():
	enemies_killed = 0
	damage_received = 0
	damage_dealt = 0

func _physics_process(_delta: float) -> void:
	if is_burning:
		register_hit(HitData.new(self, global_position, 1, Vector2.ZERO))

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("cycle_super_attack"):
		selected_super_attack_id = (selected_super_attack_id + 1) % super_attacks.size()

func _ready() -> void:
	_on_level_changed(null, GameManager.level)
	GameManager.level_changed.connect(_on_level_changed)

func _on_level_changed(_old_level: Level, new_level: Level):
	if new_level != null:
		camera.limit_bottom = int(new_level.bottom_left.position.y)
		camera.limit_left = int(new_level.bottom_left.position.x)
		camera.limit_top = int(new_level.top_right.position.y)
		camera.limit_right = int(new_level.top_right.position.x)

func _exit_tree() -> void:
	GameManager.level_changed.disconnect(_on_level_changed)

func attack_enemies(apply_knockback: bool = false) -> void:
	for enemy_hurtbox in hitbox.get_overlapping_areas():
		var enemy = enemy_hurtbox.get_owner() as Enemy
		if enemy == null:
			continue
		enemy.register_hit(
			HitData.new(self, global_position, melee_damage, knockback if apply_knockback else Vector2.ZERO)
		)

func take_last_hit() -> HitData:
	if shield_cooldown_timer.time_left == 0 and last_hit != null:
		shield_cooldown_timer.start()
		var result = last_hit
		last_hit = null
		return result
	return null

func process_last_hit() -> bool:
	var last_hit = take_last_hit()
	if last_hit != null:
		health -= last_hit.damage
		damage_received += last_hit.damage
		return true
	return false

func register_hit(hit_data: HitData):
	call_deferred("_register_hit", hit_data)
	
func _register_hit(hit_data: HitData):
	if shield_cooldown_timer.time_left == 0 and (state_machine.current_state as PlayerState).register_hits:
		last_hit = hit_data

func _on_hurtbox_body_entered(body: Node2D) -> void:
	# fire
	if body is TileMapLayer:
		is_burning = true

func _on_hurtbox_body_exited(body: Node2D) -> void:
	# fire
	if body is TileMapLayer:
		is_burning = false

func is_alive() -> bool:
	return state_machine.current_state != %Dying
