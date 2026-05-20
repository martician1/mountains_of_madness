extends PanelContainer

@export var padding_percentage_of_size_x := 2.0
var ratio := 0.0

func _ready():
	GameManager.player_changed.connect(_on_player_changed)
	_on_player_changed(null, GameManager.player)

func _on_player_changed(old_player: Player, new_player: Player):
	if old_player:
		var old_health_component: PlayerHealthComponent = \
			Util.get_component(old_player, "HealthComponent")
		old_health_component.health_changed.disconnect(_on_stat_changed)
		old_health_component.max_health_changed.disconnect(_on_stat_changed)
	if new_player:
		var new_health_component: PlayerHealthComponent = \
			Util.get_component(new_player, "HealthComponent")
		new_health_component.health_changed.connect(_on_stat_changed)
		new_health_component.max_health_changed.connect(_on_stat_changed)
	update_healthbar()

func _on_stat_changed(_old, _new):
	update_healthbar()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_SORT_CHILDREN:
		update_healthbar()

func update_healthbar():
	if GameManager.player:
		var health_component: PlayerHealthComponent = \
			Util.get_component(GameManager.player, "HealthComponent")
		ratio = float(health_component.health) / float(health_component.max_health)

	var padding := padding_percentage_of_size_x / 100.0 * size.x
	var width: float = clamp(ratio, 0.0, 1.0) * (size.x - 2 * padding)
	var height := size.y - 2 * padding
	fit_child_in_rect($Health, Rect2(Vector2(padding, padding), Vector2(width, height)))
