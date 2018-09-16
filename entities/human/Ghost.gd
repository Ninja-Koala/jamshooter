extends "res://entities/human/HumanEnemyBase.gd"

const ACCELERATION = Vector2(15, 15)
const MAX_VELOCITY = Vector2(120, 120)
const FRICTION = Vector2(10, 10)

func _ready():
	body_scene = preload("res://entities/human/DeadGhost.tscn")
	next_scene = preload("res://entities/human/Ghost.tscn")
	hitpoints = 10
	respawn_time = 3
	
	physics.init(ACCELERATION, FRICTION, Vector2(0, 0), 0, MAX_VELOCITY)

func enemy_process(delta):
	# Weg zum Spieler
	var move_force = (player.global_position - global_position).normalized()
	
	# Bewegung
	physics_fly(physics, move_force)
	
	# Spieler verletzen
	try_hit_player()