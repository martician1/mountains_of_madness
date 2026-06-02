class_name GravityComponent
extends Component

@export var body: PhysicsBody2D
@export var gravity_scale : float = 1.0

func get_gravity():
	return body.get_gravity() * gravity_scale
