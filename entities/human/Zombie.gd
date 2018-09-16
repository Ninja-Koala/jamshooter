extends "res://entities/human/HumanEnemyBase.gd"

const ACCELERATION_X = 5
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY = Vector2(200, 1000)
const FRICTION = Vector2(30, 0)
const GRAVITY = Vector2(0, 40)

const MIN_DISTANCE = Vector2(1, 0)
const MAX_STILL_TIME = 0.3

var key_force = Vector2(0, 0)
var still_time = 0

var path

func _ready():
	body_scene = preload("res://entities/human/DeadZombie.tscn")
	next_scene = preload("res://entities/human/Ghost.tscn")
	respawn_time = 3
	hitpoints = 10
	
	physics.init(Vector2(ACCELERATION_X, 0), FRICTION, GRAVITY, JUMP_VELOCITY_Y, MAX_VELOCITY)

func enemy_process(delta):
	path = get_path_to_player()
	update()
	
	# Steuere den nächsten Punkt an
	var direction = null
	if path != null && path.size() > 0:
		for p in path:
			if (p - global_position).length() > 50: #Threshold, damit sie sich nicht zu sehr mit nahen Punkten befassen
				direction = p - global_position
				break
	
	if direction == null:
		# Direkten Weg zum Spieler nehmen
		if player != null:
			direction = player.global_position - global_position
		else:
			direction = Vector2(0,0)
	
	# Bewege in diese Richtung
	key_force = Vector2(sign(direction.x), 0)
	if abs(direction.x) < MIN_DISTANCE.x:
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
	physics_move(physics, key_force)
	
	# Lavatod
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		var entity = collision.collider
		
		if entity.get_class() == "TileMap":
			var pos = collision.position - collision.normal*16 - entity.global_position
			var tile_pos=pos/64
				
			var tile_x = floor(tile_pos.x)
			var tile_y = floor(tile_pos.y)
			
			var cur_cell=entity.get_cell(tile_x,tile_y)
			var cell_name = entity.tile_set.tile_get_name(cur_cell)
			
			if cell_name == "Lava":
				destroy()

func _draw():
	if DEBUG:
		if path != null:
			for p in path:
				draw_circle(p - global_position, 5, Color(1, 0, 0, 1))