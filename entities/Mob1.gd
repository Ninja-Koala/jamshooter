extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const ACCELERATION_FACTOR = Vector2(15, 20)
const MAX_SPEED = Vector2(120, 200)
const FRICTION = Vector2(10, 10)

var move_force = Vector2(0, 0)
var speed = Vector2(0, 0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	var player = get_parent().get_node("Player")
	var move_unscaled = player.get_transform().get_origin()-get_transform().get_origin()
	move_force=move_unscaled*1/move_unscaled.length()

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
