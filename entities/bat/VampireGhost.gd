extends "res://entities/bat/BatEnemyBase.gd"

const ACCELERATION = Vector2(50, 50)
const MAX_VELOCITY = Vector2(220, 220)
const FRICTION = Vector2(30, 30)

var path

func _ready():
	body_scene = preload("res://entities/bat/DeadVampireGhost.tscn")
	next_scene = preload("res://entities/bat/VampireGhost.tscn")
	level = 1
	respawn_time = 1
	hitpoints = 2
	
	physics.init(ACCELERATION, FRICTION, Vector2(0, 0), 0, MAX_VELOCITY)

func enemy_process(delta):
	# Finde einen Pfad zum Spieler
	path = get_path_to_player()
	print(path)
	update()
	
	# Steuere den ersten Punkt an
	var direction = null
	if path != null && path.size() > 0:
		var target = null
		for p in path:
			if (p - global_position).length_squared() > 2:
				direction = (p - global_position).normalized()
				break
		
	if direction == null:
		if player != null:
			# Fliege direkt zum Spieler
			direction = (player.global_position - global_position).normalized()
		else:
			direction = Vector2(0, 0)
	
	# Fliege da hin
	physics_fly(physics, direction)

func _draw():
	if DEBUG:
		if path != null:
			for p in path:
				draw_circle(p - global_position, 5, Color(1, 0, 0, 1))