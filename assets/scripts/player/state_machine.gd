class_name PlayerStateMachine
extends StateMachine

@onready var player: Player = get_owner()
@onready var hitbox: Area2D = %Hitbox
@onready var mana_component: PlayerManaComponent = %ManaComponent
@onready var super_attack_component: PlayerSuperAttackComponent = %SuperAttackComponent
@onready var attack_cooldown_component: AttackCooldownComponent = %AttackCooldownComponent

func consume_super_attack_input():
	if Input.is_action_just_pressed("cheat_super_attack"):
		return true
	if Input.is_action_just_pressed("super_attack") and \
		mana_component.mana >= super_attack_component.selected_super_attack.mana:
		mana_component.mana -= super_attack_component.selected_super_attack.mana
		return true
	return false

# helper function used by many states to
# decide to which state to transition
func decide_next_state() -> State:
	var is_attack_pressed = Input.is_action_just_pressed("attack")
	var is_crouch_pressed = Input.is_action_pressed("crouch")
	var is_on_floor = player.is_on_floor()

	if not attack_cooldown_component.is_attack_cooldown_active():
		if consume_super_attack_input():
			return %SuperAttack
		if is_attack_pressed:
			if is_on_floor and player.max_ground_attack_combo > 0:
				return %GroundAttack
			elif not is_on_floor:
				return %PlungeCharge if is_crouch_pressed else %AirAttack
	if is_on_floor and is_crouch_pressed:
		return %Crouch
	return %Movement
