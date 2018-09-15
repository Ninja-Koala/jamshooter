extends KinematicBody2D

const FLOOR_NORMAL = Vector2(0, -1)

export var hitpoints = 1
var velocity = Vector2(0, 0)

func take_damage(damage):
	print("ow!")
	hitpoints -= damage
	if hitpoints <= 0:
		die()

func die():
	pass

func destroy():
	get_parent().remove_child(self)

func physics_move(settings, key_force):
	# Beschleunigung berechnen
	var acceleration = Vector2(key_force.x * (settings.acceleration_x + settings.friction.x), 0)
	var friction = Vector2(-sign(velocity.x) * settings.friction.x, -sign(velocity.y) * settings.friction.y)
	var move_velocity = velocity + acceleration + friction + Vector2(0, settings.gravity)
	
	# Anhalten, wenn zu langsam
	if abs(move_velocity.x) <= 1.1 * settings.friction.x:
		move_velocity.x = 0
	
	# Gravitation
	if is_on_floor():
		if key_force.y < 0:
			move_velocity.y = settings.jump_velocity - settings.gravity
	
	# Geschwindigkeit begrenzen
	if abs(move_velocity.x) > settings.max_velocity.x:
		move_velocity.x = sign(move_velocity.x) * settings.max_velocity.x
	if move_velocity.y > settings.max_velocity.y:
		move_velocity.y = settings.max_velocity.y
	
	# Bewegung
	velocity = move_and_slide(move_velocity, FLOOR_NORMAL)
	
	# Kollisionen
	var collision = get_slide_collision(0)
	if collision == null:
		return null
	else:
		return collision.collider

func draw_dashed_line(start, end, dash_length, color, width):
	var delta = dash_length * (end - start).normalized()
	var current = start
	var segments = (end - start).length() / (dash_length * 2)
	for i in range(segments):
		var next = current + delta
		draw_line(current, next, color, width)
		current = next + delta