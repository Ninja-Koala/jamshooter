extends "res://entities/wallshooter/WallshooterEnemyBase.gd"

const ACCELERATION_Y = 50
const FRICTION = Vector2(10, 10)
const MAX_VELOCITY = Vector2(50, 300)

const SHOOT_TIME = 2
const WAIT_TIME_BEFORE = 0.2
const WAIT_TIME_AFTER = 0.8
const PROJECTILE_LIFETIME = 0.2

onready var projectile_offset = get_node("Content/ProjectileOffset")

var time_until_shot = SHOOT_TIME
var shoot_phase = 0
var wait_time = 0

func _ready():
	physics.init(Vector2(0, ACCELERATION_Y), FRICTION, GRAVITY, 0, MAX_VELOCITY)
	
	next_scene = preload("res://entities/wallshooter/Wallracer.tscn")
	body_scene = preload("res://entities/wallshooter/DeadWallrunner.tscn")
	hitpoints = 4
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
				var shot = shoot_at_player(projectile_offset, PROJECTILE_LIFETIME)
				
				# Geschossen?
				if shot:
					# Starte Warte
					shoot_phase = 2
					wait_time = WAIT_TIME_AFTER
				else:
					# Mach normal weiter
					shoot_phase = 0
					time_until_shot = SHOOT_TIME
		else:
			# Warte
			wait_time -= delta
			if wait_time <= 0:
				# Mach normal weiter
				shoot_phase = 0
				time_until_shot = SHOOT_TIME
	else:
		.enemy_process(delta)