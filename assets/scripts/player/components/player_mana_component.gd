class_name PlayerManaComponent
extends Component

signal mana_changed(old: int, new: int)
signal max_mana_changed(old: int, new: int)

@export var max_mana: int = 32:
	set(value):
		var old_max_mana = max_mana
		max_mana = value
		max_mana_changed.emit(old_max_mana, max_mana)

@export var mana: int = 0:
	set(value):
		var old_mana = mana
		mana = clamp(value, 0, max_mana)
		mana_changed.emit(old_mana, mana)
