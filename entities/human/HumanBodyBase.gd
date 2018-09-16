extends "res://entities/BodyBase.gd"

const GRAVITY = Vector2(0, 40)
const MAX_VELOCITY = Vector2(200, 1000)

func _ready():
	physics.init(Vector2(0, 0), Vector2(0, 0), GRAVITY, 0, MAX_VELOCITY)