extends "res://entities/Enemy.gd"

const ACCELERATION_FACTOR = Vector2(15, 20)
const MAX_SPEED = Vector2(120, 200)
const FRICTION = Vector2(10, 10)

onready var player = get_parent().get_node("Player")
onready var dead_scene = load("res://entities/DeadEnemy.tscn")

var move_force = Vector2(0, 0)
var speed = Vector2(0, 0)

func _ready():
	hitpoints = 10
	

func die():
	print("argh!")
	var dead = dead_scene.instance()
	get_parent().add_child(dead)
	dead.position = position
	destroy()

func _process(delta):
	var move_unscaled = player.get_transform().get_origin()-get_transform().get_origin()
	move_force=move_unscaled / move_unscaled.length()

func _physics_process(delta):
	# Beschleunigung berechnen
	var acceleration = move_force * ACCELERATION_FACTOR
	var friction = Vector2(-sign(speed.x) * FRICTION.x, -sign(speed.y) * FRICTION.y)
	var move_speed = acceleration + speed + friction
	
	# Geschwindigkeit begrenzen
	if abs(move_speed.x) > MAX_SPEED.x:
		move_speed.x = sign(move_speed.x) * MAX_SPEED.x
	if abs(move_speed.y) > MAX_SPEED.y:
		move_speed.y = sign(move_speed.y) * MAX_SPEED.y
	
	# Bewegung
	speed = move_and_slide(move_speed)
