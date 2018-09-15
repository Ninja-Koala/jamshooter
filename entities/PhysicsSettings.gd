extends Object

export var acceleration = Vector2(0, 0)
export var friction = Vector2(0, 0)
export var gravity = Vector2(0, 0)
export var jump_velocity = 0
export var max_velocity = Vector2(0, 0)

func init(acceleration, friction, gravity, jump_velocity, max_velocity):
	self.acceleration = acceleration
	self.friction = friction
	self.gravity = gravity
	self.jump_velocity = jump_velocity
	self.max_velocity = max_velocity