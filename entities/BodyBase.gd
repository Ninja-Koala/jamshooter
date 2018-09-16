extends "res://entities/Entity.gd"

const GRAVITY = Vector2(0, 40)
const MAX_VELOCITY = Vector2(200, 1000)

var level
var next_scene
var respawn_time = 3.402823e+38

func _ready():
	physics.init(Vector2(0, 0), Vector2(0, 0), GRAVITY, 0, MAX_VELOCITY)
	pass

func init(level, next_scene, respawn_time = 3.402823e+38):
	self.level = level
	self.next_scene = next_scene
	self.respawn_time = respawn_time

func _physics_process(delta):
	physics_move(physics, Vector2(0, 0))
	
	respawn_time -= delta
	if respawn_time <= 0:
		if next_scene != null:
			spawn_next()
		destroy()

func spawn_next():
	var next = next_scene.instance()
	next.position = position
	next.level = level
	get_parent().add_child(next)
	return next