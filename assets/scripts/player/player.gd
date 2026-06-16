class_name Player
extends CharacterBody2D

@export var speed = 120.0
@export var jump_speed = 360.0
@export var plunge_speed = 500.0

@export var max_jump_combo := 2
@export var max_ground_attack_combo := 3

@export var melee_damage := 2
@export var crouch_attack_damage := 1
@export var plunge_attack_damage := 1

@onready var state_machine: PlayerStateMachine = %StateMachine
var last_ground_position: Vector2

var enemies_killed := 0
var damage_received := 0
var damage_dealt := 0

func reset_stats():
	enemies_killed = 0
	damage_received = 0
	damage_dealt = 0

func is_alive() -> bool:
	return state_machine.current_state != %Dying
