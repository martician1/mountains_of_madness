class_name PlayerSuperAttackComponent
extends Component

signal selected_super_attack_changed(old: SuperAttackData, new: SuperAttackData)

@export var super_attacks: Array[SuperAttackData]

var selected_super_attack_id: int = 0:
	set(value):
		var old_super_attack_id = selected_super_attack_id
		selected_super_attack_id = value

		selected_super_attack_changed.emit(
			super_attacks[selected_super_attack_id],
			super_attacks[old_super_attack_id]
		)

var selected_super_attack: SuperAttackData:
	set(_val):
		printerr("Invalid attempt to set derived property `selected_super_attack`, try setting `super_attacks` and `selected_super_attack_id` properties instead")
		return
	get():
		return super_attacks[selected_super_attack_id]

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("cycle_super_attack"):
		selected_super_attack_id = (selected_super_attack_id + 1) % super_attacks.size()

func spawn_super_attack() -> SuperAttack:
	# TODO: preload super attack
	var super_attack_node = load(selected_super_attack.scene_path).instantiate()
	GameManager.level.add_child(super_attack_node)
	return super_attack_node
