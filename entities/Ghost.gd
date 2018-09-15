extends "res://entities/Enemy.gd"

const ACCELERATION_FACTOR = Vector2(15, 20)
const MAX_SPEED = Vector2(120, 200)
const FRICTION = Vector2(10, 10)

var speed = Vector2(0, 0)

func _ready():
	hitpoints = 10

func die():
	print("argh!")
	destroy()

func _physics_process(delta):
	# Weg zum Spieler
	var move_force = (player.global_position - global_position).normalized()
	
	# Beschleunigung berechnen
	var acceleration = move_force * ACCELERATION_FACTOR
	var friction = Vector2(-sign(speed.x) * FRICTION.x, -sign(speed.y) * FRICTION.y)
	var move_speed = acceleration + speed + friction
	
	# Geschwindigkeit begrenzen
	if abs(move_speed.x) > MAX_SPEED.x:
		move_speed.x = sign(move_speed.x) * MAX_SPEED.x
	if abs(move_speed.y) > MAX_SPEED.y:
		move_speed.y = sign(move_speed.y) * MAX_SPEED.y
	
	# Bewegung
	speed = move_and_slide(move_speed)
	
	# Spieler verletzen
	try_hit_player()