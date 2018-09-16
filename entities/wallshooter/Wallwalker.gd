extends "res://entities/wallshooter/WallshooterEnemyBase.gd"

const ACCELERATION_Y = 50
const FRICTION = Vector2(10, 10)
const MAX_VELOCITY = Vector2(50, 200)

func _ready():
	print(get_transform().get_scale().x)
	physics.init(Vector2(0, ACCELERATION_Y), FRICTION, GRAVITY, 0, MAX_VELOCITY)
	
	hitpoints = 4
	next_scene = preload("res://entities/wallshooter/Wallrunner.tscn")
	body_scene = preload("res://entities/wallshooter/DeadWallwalker.tscn")
	respawn_time = 3