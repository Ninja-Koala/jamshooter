extends "res://entities/Enemy.gd"

const FLOOR_NORMAL = Vector2(0, -1)
const ACCELERATION_X = 5
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY = Vector2(200, 1000)
const FRICTION = Vector2(30, 0)
const GRAVITY = 40
const MIN_DISTANCE = Vector2(1, 0)
const MAX_STILL_TIME = 0.3

var physics_type = preload("res://entities/PhysicsSettings.gd")
var physics
onready var dead_scene = load("res://entities/DeadEnemy.tscn")

var key_force = Vector2(0, 0)

var still_time = 0

func _ready():
	hitpoints = 10
	physics = physics_type.new()
	physics.init(ACCELERATION_X, FRICTION, GRAVITY, JUMP_VELOCITY_Y, MAX_VELOCITY)

func die():
	print("argh!")
	var dead = dead_scene.instance()
	get_parent().add_child(dead)
	dead.position = position
	destroy()

func _physics_process(delta):
	# Weg zum Spieler ermitteln
	var player_direction = player.global_position - global_position;
	key_force = Vector2(sign(player_direction.x), 0)
	
	if abs(player_direction.x) < MIN_DISTANCE.x:
		key_force.x = 0
	
	# Stillstand?
	if velocity.length_squared() == 0:
		still_time += delta
	else:
		still_time = 0
	
	# Wie lange?
	if still_time > MAX_STILL_TIME:
		key_force.y = -1
	
	# Physik
	var collider = physics_move(physics, key_force)
	
	# Schaden
	try_hit_player()