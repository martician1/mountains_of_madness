extends PanelContainer

func _ready():
	GameManager.player_changed.connect(_on_player_changed)
	_on_player_changed(null, GameManager.player)

func _on_player_changed(old_player: Player, new_player: Player):
	if old_player:
		old_player.selected_super_attack_changed.disconnect(_on_selected_super_attack_change)
	if new_player:
		new_player.selected_super_attack_changed.connect(_on_selected_super_attack_change)
	_on_selected_super_attack_change(
		old_player.selected_super_attack if old_player else null,
		new_player.selected_super_attack if new_player else null
	)

func _on_selected_super_attack_change(old: SuperAttack, new: SuperAttack):
	if old:
		old.ui_texture_changed.disconnect(_on_ui_texture_changed)
	if new:
		new.ui_texture_changed.connect(_on_ui_texture_changed)
	_on_ui_texture_changed(
		old.ui_texture if old else null,
		new.ui_texture if new else null
	)

func _on_ui_texture_changed(_old, _new):
	update_super_attack()

func update_super_attack():
	var player := GameManager.player
	if player and player.selected_super_attack:
		$SuperAttackTexture.texture = player.selected_super_attack.ui_texture
