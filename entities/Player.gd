extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)
const ACCELERATION_X = 45
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY_X = 280
const MAX_FALL_VELOCITY = 1000
const FRICTION = Vector2(30, 0)
const GRAVITY = 40

const MOUSE_SENSITIVITY = 0.01

var key_force = Vector2(0, 0)
var velocity = Vector2(0, 0)

var crosshair_position = Vector2(1, -1).normalized()

var shoot_button_pressed = false

onready var collision_box = get_node("CollisionBox")
onready var projectile_scene = load("res://entities/PlayerProjectile.tscn")
onready var projectile_offset = get_node("ProjectileSpawn").position.length()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventKey:
		key_force = Vector2()
		
		if Input.is_key_pressed(KEY_SPACE):
			key_force.y -= 1
		
		if Input.is_key_pressed(KEY_D):
			key_force.x += 1
		if Input.is_key_pressed(KEY_A):
			key_force.x -= 1
	elif event is InputEventMouseMotion:
		crosshair_position = (crosshair_position + MOUSE_SENSITIVITY * event.relative).normalized()
		update()
	elif event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				shoot_button_pressed = true
			else:
				shoot_button_pressed = false

func _physics_process(delta):
	# Beschleunigung berechnen
	var acceleration = Vector2(key_force.x * ACCELERATION_X, 0)
	var friction = Vector2(-sign(velocity.x) * FRICTION.x, -sign(velocity.y) * FRICTION.y)
	var move_velocity = velocity + acceleration + friction + Vector2(0, GRAVITY)
	
	# Anhalten, wenn zu langsam
	if abs(move_velocity.x) <= 1.1 * FRICTION.x:
		move_velocity.x = 0
	
	# Gravitation
	if is_on_floor():
		if key_force.y < 0:
			move_velocity.y = JUMP_VELOCITY_Y
	
	# Geschwindigkeit begrenzen
	if abs(move_velocity.x) > MAX_VELOCITY_X:
		move_velocity.x = sign(move_velocity.x) * MAX_VELOCITY_X
	if move_velocity.y > MAX_FALL_VELOCITY:
		move_velocity.y = MAX_FALL_VELOCITY
	
	# Bewegung
	velocity = move_and_slide(move_velocity, FLOOR_NORMAL)
	if velocity.x > 300:
		print(velocity)
	
	# Projektile
	if shoot_button_pressed:
		shoot_button_pressed = false
		var projectile = projectile_scene.instance()
		get_parent().add_child(projectile)
		projectile.position = position + (projectile_offset * crosshair_position)
		projectile.rotation = Vector2(1, 0).angle_to(crosshair_position)
		projectile.direction = (projectile.position - position).normalized()
		projectile.update_physics()
		print("bang")

func _draw():
	var length = 2 * max(get_viewport().size.x, get_viewport().size.y)
	var scale = get_transform().get_scale()
	var target = crosshair_position * length
	target.x *= scale.y / scale.x
	draw_dashed_line(Vector2(), target, 8, Color(1, 0, 0, 0.5), 2)

func draw_dashed_line(start, end, dash_length, color, width):
	var delta = dash_length * (end - start).normalized()
	var current = start
	var segments = (end - start).length() / (dash_length * 2)
	for i in range(segments):
		var next = current + delta
		draw_line(current, next, color, width)
		current = next + delta