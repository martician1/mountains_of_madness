extends RefCounted
class_name HitData

var performed_by: Node2D
var from_position: Vector2
var damage: int
var knockback: Vector2

func _init(_performed_by: Node2D, _from_position: Vector2, _damage: int, _knockback: Vector2) -> void:
	self.performed_by = _performed_by
	self.from_position = _from_position
	self.damage = _damage
	self.knockback = _knockback
