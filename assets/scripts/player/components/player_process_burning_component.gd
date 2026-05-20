class_name PlayerProcessBurningComponent
extends Component

var burn_damage := 1
var is_burning := false
@onready var player: Player = get_owner()
@export var hit_processing_component: PlayerHitProcessingComponent
@export var hurtboxes: Array[Area2D]

func _ready() -> void:
	for hurtbox in hurtboxes:
		hurtbox.body_entered.connect(_on_hurtbox_body_entered)
		hurtbox.body_exited.connect(_on_hurtbox_body_exited)

func _physics_process(_delta: float) -> void:
	if is_burning:
		hit_processing_component.register_hit(
			HitData.new(player, player.global_position, burn_damage, Vector2.ZERO)
		)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is TileMapLayer:
		is_burning = true

func _on_hurtbox_body_exited(body: Node2D) -> void:
	if body is TileMapLayer:
		is_burning = false
