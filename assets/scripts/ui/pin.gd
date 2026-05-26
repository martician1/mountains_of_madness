class_name Pin
extends TextureRect

enum Status {
	UNLOCKED,
	LOCKED,
	INVALID
}

@export var pin_data: PinData
@export var variant: int
@export var level_number: int
@export var status: Status

func _ready() -> void:
	%TextureRect.texture = pin_data.textures[variant]
	if status != Status.INVALID:
		status = Status.UNLOCKED if level_number <= GameState.highest_level else Status.LOCKED
	modulate = pin_data.status_color_masks[status]

func _on_mouse_entered() -> void:
	scale  = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	scale  = Vector2(1.0, 1.0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and status == Status.UNLOCKED:
			GameManager.load_level(level_number)
