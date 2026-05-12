class_name EvilPrincessBoss
extends Enemy

signal attack_finished()

@export var chase_height := -110.0
@export var attack_speed := 200.0
@export var max_x_offset_for_attack := 5.0

@onready var state_machine: StateMachine = %StateMachine
@onready var attack_hitbox: Area2D = %AttackHitbox
@onready var body_hitbox: Area2D = %BodyHitbox
@onready var flash_effect: FlashEffect = %FlashEffect

func try_hit_player():
	if is_player_in_hitbox(attack_hitbox) or is_player_in_hitbox(body_hitbox):
		hit_player()

func process_last_hit(register_knockback: bool = false) -> bool:
	if not super.process_last_hit(register_knockback):
		return false
	if health <= 0:
		state_machine.scheduled_state = %Dying
	flash_effect.flash()
	return true

func can_attack_player() -> bool:
	var player_x_offset = GameManager.player.global_position.x - global_position.x
	return abs(player_x_offset) <= max_x_offset_for_attack
