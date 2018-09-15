extends "res://entities/HumanEnemyBase.gd"

const ACCELERATION = Vector2(15, 15)
const MAX_VELOCITY = Vector2(120, 120)
const FRICTION = Vector2(10, 10)

func _ready():
	hitpoints = 10
	physics.init(ACCELERATION, FRICTION, Vector2(0, 0), 0, MAX_VELOCITY)

func _physics_process(delta):
	# Weg zum Spieler
	var move_force = (player.global_position - global_position).normalized()
	
	# Bewegung
	physics_fly(physics, move_force)
	
	# Spieler verletzen
	try_hit_player()