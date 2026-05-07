class_name HealthDrop
extends Area2D

@export var despawn_time := 0.0
@export var fadeout_time := 0.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
var timer: SceneTreeTimer

func _on_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		GameManager.player.health += 1
		queue_free()

func _ready() -> void:
	if despawn_time == 0.0 or fadeout_time == 0.0:
		set_process(false)

	if despawn_time != 0.0:
		timer = get_tree().create_timer(despawn_time)
		await timer.timeout
		queue_free()

func _process(_delta: float) -> void:
	sprite.modulate.a = clamp(timer.time_left / fadeout_time, 0.0, 1.0)
