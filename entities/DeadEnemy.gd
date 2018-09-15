extends "res://entities/Entity.gd"

const GRAVITY = 40
const MAX_VELOCITY = Vector2(200, 1000)

var physics_type = preload("res://entities/PhysicsSettings.gd")
var physics

func _ready():
	physics = physics_type.new()
	physics.init(0, Vector2(0, 0), GRAVITY, 0, MAX_VELOCITY)
	pass

func _physics_process(delta):
	physics_move(physics, Vector2(0, 0))