extends "res://entities/Entity.gd"

const FLOOR_NORMAL = Vector2(0, -1)
const ACCELERATION_X = 15
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY_X = 280
const MAX_FALL_VELOCITY = 1000
const FRICTION = Vector2(30, 0)
const GRAVITY = 40
const HOOK_AIRCONTROL = 1

const MOUSE_SENSITIVITY = 0.01

const AIRCONTROL_ACCELERATION=550
const AIRCONTROL_GRAVITY = 500

const INVINCIBILITY_DURATION = 0.5

var key_force = Vector2(0, 0)

var crosshair_position = Vector2(1, -1).normalized()

var shoot_button_pressed = false
var hook_active = false
var hook_pulls = false

var invincibility = 0

onready var collision_box = get_node("CollisionBox")
onready var projectile_scene = load("res://entities/PlayerProjectile.tscn")
onready var projectile_offset = get_node("ProjectileSpawn").position.length()

onready var hook_scene = load("res://entities/Hook.tscn")
onready var hook_offset = get_node("HookSpawn").position.length()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hitpoints = 5

func take_damage(damage):
	if invincibility <= 0:
		.take_damage(damage)
		invincibility = INVINCIBILITY_DURATION

func die():
	destroy()

func _input(event):
	if event is InputEventKey:
		key_force = Vector2()
		
		if Input.is_action_pressed("jump"):
			key_force.y -= 1
		
		if Input.is_action_pressed("move_right"):
			key_force.x += 1
		if Input.is_action_pressed("move_left"):
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
		elif event.button_index == BUTTON_RIGHT:
			if event.pressed:
				hook_active = true
			else:
				hook_active = false

func _physics_process(delta):
	# Beschleunigung berechnen
	var acceleration = Vector2(key_force.x * (ACCELERATION_X + FRICTION.x), 0)
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
		
	# Haken
	if hook_active:
		if get_parent().has_node("Hook"):
			var hook = get_parent().get_node("Hook")
			
			if hook.hooked:
				move_hooked(hook)
			else:
				move_unhooked(false)
		else:
			var hook = hook_scene.instance()
			get_parent().add_child(hook)
			hook.position = position + (hook_offset * crosshair_position)
			hook.rotation = Vector2(1, 0).angle_to(crosshair_position)
			hook.direction = (hook.position - position).normalized()
			hook.update_physics()
			move_unhooked(false)
	else:
		move_unhooked(false)
		if get_parent().has_node("Hook"):
			get_parent().remove_child(get_parent().get_node("Hook"))
	
	# Unverwundbarkeit nach Treffer
	invincibility -= delta

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
		
func move(move_velocity):
	# Bewegung
	velocity = move_and_slide(move_velocity, FLOOR_NORMAL)
		
func get_vertical_comp(of_vector,to_vector):
	var x = of_vector-((to_vector.dot(of_vector))/(to_vector.dot(to_vector)))*to_vector
	return x
	
func move_unhooked(jump_ungrounded):
	# Beschleunigung berechnen
	var acceleration = Vector2(key_force.x * ACCELERATION_X, 0)
	var friction = Vector2(-sign(velocity.x) * FRICTION.x, -sign(velocity.y) * FRICTION.y)
	var move_velocity = velocity + acceleration + friction + Vector2(0, GRAVITY)
	
	# Anhalten, wenn zu langsam
	if abs(move_velocity.x) <= 1.1 * FRICTION.x:
		move_velocity.x = 0
	
	# Gravitation
	if is_on_floor() or jump_ungrounded:
		if key_force.y < 0:
			move_velocity.y = JUMP_VELOCITY_Y
	
	# Geschwindigkeit begrenzen
	if abs(move_velocity.x) > MAX_VELOCITY_X:
		move_velocity.x = sign(move_velocity.x) * MAX_VELOCITY_X
	if move_velocity.y > MAX_FALL_VELOCITY:
		move_velocity.y = MAX_FALL_VELOCITY
	move(move_velocity);

func move_hooked(hook):
	if key_force.y==0:
		var dir = (hook.position-position).normalized()
		var dir_scaled = dir*hook.pull_strength
		var key_force_dir = Vector2(key_force.x, 0)
		var key_force_vert = get_vertical_comp(key_force_dir,dir)*AIRCONTROL_ACCELERATION;
		var grav_vert = get_vertical_comp(Vector2(0, AIRCONTROL_GRAVITY),dir);
		
		move_and_slide(dir_scaled)
		move_and_slide(key_force_vert+grav_vert)
	else:
		move_unhooked(true)
		hook_active=false