extends "res://entities/PhaseEnemy.gd"

const GRAVITY = Vector2(50, 0)

onready var floor_scan_bottom = get_node("Content/WallScanArea/bottom")
onready var floor_scan_top = get_node("Content/WallScanArea/top")
onready var content_node = get_node("Content")
onready var projectile_scene = preload("res://entities/wallshooter/WallrunnerProjectile.tscn")

var initialized = false

var direction = 1
var key_force
export var flipped = false

func enemy_process(delta):
	try_hit_player()
	# Noch nicht initialisiert?
	if !initialized:
		if flipped:
			var transform = content_node.get_transform()
			transform = transform.scaled(Vector2(-1, 1))
			content_node.set_transform(transform)
		
		flipped = content_node.get_global_transform()[0][0] < 0
		if flipped:
			physics.gravity *= -1
		initialized = true
	
	# Gibt es noch Wand?
	var direction_node
	if direction > 0:
		direction_node = floor_scan_bottom
	else:
		direction_node = floor_scan_top
	var floors = direction_node.get_overlapping_bodies()
	var found = false
	for f in floors:
		if f is TileMap:
			found = true
			break;
	
	# Wenn nicht, umdrehen
	if !found:
		direction = -direction
		
	# Laufe hoch/runter
	key_force = Vector2(0, direction)
	
	# Bewegung
	var velocity_before = velocity
	physics_fly(physics, key_force)
	
	# Nicht bewegt?
	if velocity_before == Vector2(0, 0) && velocity == Vector2(0, 0):
		direction = -direction

func spawn_body():
	var body = .spawn_body()
	if flipped:
		body.flip()
	return body

func shoot_at_player(projectile_offset, lifetime, only_forward = true):
	if player == null:
		return false
	
	var direction = (player.global_position - global_position).normalized()
	var projectile_position = projectile_offset.global_position
	
	# Nicht nach hinten schießen
	if only_forward && direction.dot(projectile_position - global_position) < 0:
		return false
	
	var projectile = projectile_scene.instance()
	projectile.direction = direction
	projectile.position = projectile_position - get_parent().position
	projectile.lifetime = lifetime
	get_parent().add_child(projectile)
	return true