extends "res://entities/bat/BatEnemyBase.gd"

const ACCELERATION = Vector2(50, 50)
const MAX_VELOCITY = Vector2(200, 200)
const FRICTION = Vector2(30, 30)

const MIN_DIRECTION_TIME = 1
const MAX_DIRECTION_TIME = 2.5

var direction = Vector2(1, 0)
var direction_time = 0

func _ready():
	body_scene = preload("res://entities/bat/DeadBat.tscn")
	next_scene = preload("res://entities/bat/Vampire.tscn")
	level = 1
	respawn_time = 3
	hitpoints = 2
	
	physics.init(ACCELERATION, FRICTION, Vector2(0, 0), 0, MAX_VELOCITY)

func enemy_process(delta):
	# Wähle eine zufällige Richtung
	if direction_time <= 0:
		direction_time = rand_range(MIN_DIRECTION_TIME, MAX_DIRECTION_TIME)
		direction = Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()
	
	# Fliege in diese Richtung
	physics_fly(physics, direction)
	
	# Hindernis getroffen?
	if get_slide_count() != 0:
		# Ändere im nächsten Frame die Richtung
		direction_time = 0
	
	# Zähle die Zeit runter
	direction_time -= delta
	
	# Schaden
	try_hit_player()