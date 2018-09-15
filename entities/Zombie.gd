extends "res://entities/HumanEnemyBase.gd"

const ACCELERATION_X = 5
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY = Vector2(200, 1000)
const FRICTION = Vector2(30, 0)
const GRAVITY = 40

const MIN_DISTANCE = Vector2(1, 0)
const MAX_STILL_TIME = 0.3

var key_force = Vector2(0, 0)
var still_time = 0

var path

func _ready():
	body_scene = preload("res://entities/DeadEnemy.tscn")
	next_scene = preload("res://entities/Ghost.tscn")
	level = 1
	respawn_time = 3
	hitpoints = 10
	
	physics.init(Vector2(ACCELERATION_X, 0), FRICTION, GRAVITY, JUMP_VELOCITY_Y, MAX_VELOCITY)

func _physics_process(delta):
	path = get_path_to_player()
	update()
	
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

func _draw():
	if path != null:
		for p in path:
			draw_circle(p - global_position, 5, Color(1, 0, 0, 1))