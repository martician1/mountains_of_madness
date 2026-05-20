extends PanelContainer

@export var padding_percentage_of_size_y := 3
@export var threshold_line_height := 1
var mana_ratio := 0.0
var threshold_ratio := 0.0

func _ready():
	GameManager.player_changed.connect(_on_player_changed)
	_on_player_changed(null, GameManager.player)

func _on_player_changed(old_player: Player, new_player: Player):
	var old_mana_component: PlayerManaComponent
	var old_super_attack_component: PlayerSuperAttackComponent
	var new_mana_component: PlayerManaComponent
	var new_super_attack_component: PlayerSuperAttackComponent

	if old_player:
		old_mana_component = Util.get_component(old_player, "ManaComponent")
		old_super_attack_component = Util.get_component(old_player, "SuperAttackComponent")

		old_mana_component.mana_changed.disconnect(_on_mana_stat_changed)
		old_mana_component.max_mana_changed.disconnect(_on_mana_stat_changed)
		old_super_attack_component.selected_super_attack_changed.disconnect(
			_on_selected_super_attack_change
		)
	if new_player:
		new_mana_component = Util.get_component(new_player, "ManaComponent")
		new_super_attack_component = Util.get_component(new_player, "SuperAttackComponent")

		new_mana_component.mana_changed.connect(_on_mana_stat_changed)
		new_mana_component.max_mana_changed.connect(_on_mana_stat_changed)
		new_super_attack_component.selected_super_attack_changed.connect(
			_on_selected_super_attack_change
		)
	
	_on_selected_super_attack_change(
		old_super_attack_component.selected_super_attack if old_super_attack_component else null,
		new_super_attack_component.selected_super_attack if new_super_attack_component else null,
	)
		
func _on_mana_stat_changed(_old, _new):
	update_manabar()

func _on_selected_super_attack_change(old: SuperAttackData, new: SuperAttackData):
	_on_mana_stat_changed(old.mana if old else null, new.mana if new else null)

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		update_manabar()

func update_manabar():
	if GameManager.player:
		var mana_component: PlayerManaComponent = \
			Util.get_component(GameManager.player, "ManaComponent")
		var super_attack_component: PlayerSuperAttackComponent = \
			Util.get_component(GameManager.player, "SuperAttackComponent")

		mana_ratio = float(mana_component.mana) / float(mana_component.max_mana)

		threshold_ratio = float(
			super_attack_component.selected_super_attack.mana
		) / float(mana_component.max_mana)
		if mana_component.mana >= super_attack_component.selected_super_attack.mana:
			$PulseEffect.play()
		else:
			$PulseEffect.stop()

	var padding := int(padding_percentage_of_size_y / 100.0 * size.y)

	var get_rectangle_from_ratio = func(ratio: float, add_horizontal_padding := false):
		var padding_x := padding if add_horizontal_padding else 0
		var padding_y := padding
		
		var height := int(clamp(ratio, 0.0, 1.0) * (size.y - 2 * padding_y))
		var width := int(size.x - 2 * padding_x)
		return Rect2(
			Vector2(padding_x, size.y - height - padding_y),
			Vector2(width, height)
		)

	fit_child_in_rect($Mana, get_rectangle_from_ratio.call(mana_ratio, true))
	var threshold_line = get_rectangle_from_ratio.call(threshold_ratio)
	threshold_line.size.y = threshold_line_height
	fit_child_in_rect($Threshold, threshold_line)
