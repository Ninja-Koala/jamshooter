extends "res://entities/human/HumanEnemyBase.gd"

const ACCELERATION_X = 5
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY = Vector2(200, 1000)
const FRICTION = Vector2(30, 0)
const GRAVITY = 40

const MIN_DISTANCE = Vector2(1, 0)
const MAX_STILL_TIME = 0.3

var key_force = Vector2(0, 0)
var was_on_floor = false

export var direction = 1

func _ready():
	body_scene = preload("res://entities/human/DeadHuman.tscn")
	next_scene = preload("res://entities/human/Zombie.tscn")
	level = 1
	respawn_time = 3
	hitpoints = 10
	
	physics.init(Vector2(ACCELERATION_X, 0), FRICTION, GRAVITY, 0, MAX_VELOCITY)

func _physics_process(delta):
	# Laufe geradeaus
	key_force = Vector2(direction, 0)
	
	# Bewegung
	var position_before = position
	physics_move(physics, key_force)
	
	# Über eine Kante gelaufen?
	if is_on_floor():
		was_on_floor = true
	if was_on_floor && !is_on_floor() || is_on_wall():
		# Bewegung zurücksetzen
		position += 3 * (position_before - position)
		was_on_floor = false
		
		# Richtung umkehren und Bewegung stattdessen in die andere Richtung
		direction = -direction
		key_force = Vector2(direction, 0)
		physics_move(physics, key_force)
	
	# Schaden
	try_hit_player()