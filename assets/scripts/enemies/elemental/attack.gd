extends OneShotAnimationState

@onready var elemental: Elemental = get_owner()
@onready var sprite_animator: SpriteAnimator = %SpriteAnimator
@onready var state_machine: StateMachine = %StateMachine
@onready var attack_hitbox: Area2D = %AttackHitbox

@onready var attack_component: EnemyAttackComponent = %AttackComponent
@onready var speed_component: EnemySpeedComponent = %SpeedComponent
@onready var hit_processing_component: EnemyHitProcessingComponent = %HitProcessingComponent
@onready var health_component: HealthComponent = %HealthComponent

func update(delta: float) -> State:
	if attack_component.is_player_in_hitbox(attack_hitbox):
		attack_component.hit_player()
	
	elemental.velocity.x = move_toward(elemental.velocity.x, 0.0, speed_component.speed)

	if not elemental.is_on_floor():
		elemental.velocity += elemental.get_gravity() * delta
	
	elemental.move_and_slide()
	return self

func handle_input() -> State:
	if hit_processing_component.process_last_hit():
		return %Hurt if health_component.health > 0 else %Dying
	if not has_animation_finished:
		return self
	var next_state = state_machine.decide_next_state()
	if next_state == self:
		self.enter()
	return next_state
