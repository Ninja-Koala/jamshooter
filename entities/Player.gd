extends KinematicBody2D

const ACCELERATION_FACTOR = Vector2(15, 20)
const MAX_SPEED = Vector2(120, 200)
const FRICTION = Vector2(10, 10)

var key_force = Vector2(0, 0)
var speed = Vector2(0, 0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
	if event is InputEventKey:
		var key_force_x = 0
		var key_force_y = 0
		
		if Input.is_key_pressed(KEY_W):
			key_force_y -= 1
		if Input.is_key_pressed(KEY_S):
			key_force_y += 1
		
		if Input.is_key_pressed(KEY_D):
			key_force_x += 1
		if Input.is_key_pressed(KEY_A):
			key_force_x -= 1
		
		key_force = Vector2(key_force_x, key_force_y)
		
func _physics_process(delta):
	# Beschleunigung berechnen
	var acceleration = key_force * ACCELERATION_FACTOR
	var friction = Vector2(-sign(speed.x) * FRICTION.x, -sign(speed.y) * FRICTION.y)
	var move_speed = acceleration + speed + friction
	
	# Geschwindigkeit begrenzen
	if abs(move_speed.x) > MAX_SPEED.x:
		move_speed.x = sign(move_speed.x) * MAX_SPEED.x
	if abs(move_speed.y) > MAX_SPEED.y:
		move_speed.y = sign(move_speed.y) * MAX_SPEED.y
	
	# Bewegung
	speed = move_and_slide(move_speed)