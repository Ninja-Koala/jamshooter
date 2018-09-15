extends "res://entities/bat/BatEnemyBase.gd"

const ACCELERATION = Vector2(5, 5)
const MAX_VELOCITY = Vector2(200, 200)
const FRICTION = Vector2(30, 30)

var key_force = Vector2(0, 0)

func _ready():
	body_scene = preload("res://entities/bat/DeadVampire.tscn")
	#next_scene = preload("res://entities/bat/Vampire.tscn")
	level = 1
	respawn_time = 3
	hitpoints = 10
	
	physics.init(ACCELERATION, FRICTION, Vector2(0, 0), 0, MAX_VELOCITY)

func _physics_process(delta):
	# Laufe geradeaus
	key_force = Vector2(1, 0)