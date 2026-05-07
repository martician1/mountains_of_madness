extends Container

@export var adjacent_offset: int = 1
@export var far_offset: int = 10

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		var y := int(size.y)
		var bar_thickness := y / 5
		
		fit_child_in_rect($PlayerHead, Rect2(Vector2(), Vector2(y, y)))
		fit_child_in_rect($HealthBar, Rect2(Vector2(y + adjacent_offset, y - bar_thickness), Vector2(y, bar_thickness)))

		fit_child_in_rect($SuperAttack, Rect2(Vector2(2 * (y + adjacent_offset) + far_offset, 0), Vector2(y, y)))
		fit_child_in_rect($ManaBar, Rect2(Vector2(3 * (y + adjacent_offset) + far_offset, 0), Vector2(bar_thickness, y)))
