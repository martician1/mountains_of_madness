extends PanelContainer

@export var padding_percentage_of_size_y := 2.0
var mana_ratio := 0.0
var threshold_ratio := 0.0

func _ready():
	GameManager.player_changed.connect(_on_player_changed)
	_on_player_changed(null, GameManager.player)

func _on_player_changed(old_player: Player, new_player: Player):
	if old_player:
		old_player.mana_changed.disconnect(_on_mana_stat_changed)
		old_player.max_mana_changed.disconnect(_on_mana_stat_changed)
		old_player.selected_super_attack_changed.disconnect(_on_selected_super_attack_change)	
	if new_player:
		new_player.mana_changed.connect(_on_mana_stat_changed)
		new_player.max_mana_changed.connect(_on_mana_stat_changed)
		new_player.selected_super_attack_changed.connect(_on_selected_super_attack_change)
	
	_on_selected_super_attack_change(
		old_player.selected_super_attack if old_player else null,
		new_player.selected_super_attack if new_player else null,
	)
		
func _on_mana_stat_changed(_old, _new):
	update_manabar()

func _on_selected_super_attack_change(old: SuperAttackData, new: SuperAttackData):
	_on_mana_stat_changed(old.mana if old else null, new.mana if new else null)

func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		update_manabar()

func update_manabar():
	var player := GameManager.player
	if player:
		mana_ratio = float(player.mana) / float(player.max_mana)
		if player.selected_super_attack:
			threshold_ratio = float(player.selected_super_attack.mana) / float(player.max_mana)

	var get_rectangle_from_ratio = func(ratio: float, with_padding: bool):
		var padding := padding_percentage_of_size_y / 100.0 * size.y if with_padding else 0.0
		var height: float = clamp(ratio, 0.0, 1.0) * (size.y - 2 * padding)
		var width := size.x - 2 * padding
		return Rect2(Vector2(padding, size.y - height - padding), Vector2(width, height))

	fit_child_in_rect($Mana, get_rectangle_from_ratio.call(mana_ratio, true))
	fit_child_in_rect($Threshold, get_rectangle_from_ratio.call(threshold_ratio, false))
