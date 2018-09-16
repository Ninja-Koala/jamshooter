extends "res://entities/wallshooter/WallshooterEnemyBase.gd"

const ACCELERATION_Y = 50
const FRICTION = Vector2(10, 10)
const MAX_VELOCITY = Vector2(50, 300)

const SHOOT_TIME = 2
const WAIT_TIME_BEFORE = 0.5
const WAIT_TIME_AFTER = 0.5

var time_until_shot = SHOOT_TIME
var shoot_phase = 0
var wait_time = 0

func _ready():
	print(get_transform().get_scale().x)
	physics.init(Vector2(0, ACCELERATION_Y), FRICTION, GRAVITY, 0, MAX_VELOCITY)
	
	hitpoints = 4
	next_scene = preload("res://entities/wallshooter/Wallracer.tscn")
	body_scene = preload("res://entities/wallshooter/DeadWallrunner.tscn")
	respawn_time = 3

func enemy_process(delta):
	time_until_shot -= delta
	
	# Schuss?
	if time_until_shot <= 0:
		# Noch nicht geschossen?
		if shoot_phase == 0:
			# Starte Warten
			shoot_phase = 1
			wait_time = WAIT_TIME_BEFORE
		elif shoot_phase == 1:
			# Warte
			wait_time -= delta
			if wait_time <= 0:
				# Schieß
				shoot_at_player()
				shoot_phase = 2
				shoot_phase = 2
				wait_time = WAIT_TIME_AFTER
		else:
			# Warte
			wait_time -= delta
			if wait_time <= 0:
				# Mach normal weiter
				shoot_phase = 0
				time_until_shot = SHOOT_TIME
	else:
		.enemy_process(delta)

func shoot_at_player():
	print("shoot")