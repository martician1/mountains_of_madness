class_name Spawner
extends Node2D

@export var health := 10
@export var damage := 1
var last_hit: HitData
@onready var player_hit_processing_component: PlayerHitProcessingComponent = \
	Util.get_component(GameManager.player, "HitProcessingCOmponent")

func register_hit(hit_data: HitData):
	last_hit = hit_data
	if not get_tree().physics_frame.is_connected(_process_last_hit):
		get_tree().physics_frame.connect(_process_last_hit, CONNECT_ONE_SHOT)

func _process_last_hit():
	health -= last_hit.damage
	last_hit = null
	if health <= 0:
		queue_free()

func _on_area_2d_area_entered(hurtbox: Area2D) -> void:
	if hurtbox.owner == GameManager.player:
		player_hit_processing_component.register_hit(
			HitData.new(self, global_position, damage)
		)
