class_name HealthComponent
extends Component

@export var health := 1: set = set_health

func set_health(value):
	health = max(value, 0)
