extends State

@onready var imp: Imp = get_owner()
@onready var hitbox: Area2D = %Hitbox

func update(_delta: float) -> State:
	var player := GameManager.player

	if player == null or not player.is_alive():
		return self
	
	if imp.is_player_in_hitbox(hitbox):
		imp.hit_player()
		return %Dying
	
	var direction = (player.global_position - imp.global_position)
	if direction.length() <= imp.attack_radius:
		imp.direction = direction.normalized()
		imp.velocity = imp.speed * imp.direction
		imp.move_and_slide()

	return self

func handle_input() -> State:
	if imp.process_last_hit():
		if imp.health <= 0:
			return %Dying
	return self

func get_animation() -> String:
	return "idle"
