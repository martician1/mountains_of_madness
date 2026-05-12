class_name Level
extends Node2D

signal level_finished()
signal level_failed()

@export var bottom_left: Marker2D
@export var top_right: Marker2D
@export var player_spawn : Marker2D

var hell_charge_scene: PackedScene = preload("res://assets/scenes/hell_charge.tscn")
var mana_ball_scene: PackedScene = preload("res://assets/scenes/mana_ball.tscn")
var health_drop_scene: PackedScene = preload("res://assets/scenes/health_drop.tscn")
