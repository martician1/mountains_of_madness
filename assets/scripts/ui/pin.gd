extends TextureRect

@export var pin_data: PinData
@export var variant: int
@export var level_path: String

func _ready() -> void:
	%TextureRect.texture = pin_data.textures[variant]

func _on_mouse_entered() -> void:
	scale  = Vector2(1.2, 1.2)

func _on_mouse_exited() -> void:
	scale  = Vector2(1.0, 1.0)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			GameManager.load_level(level_path)
