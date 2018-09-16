extends "res://entities/human/HumanEnemyBase.gd"

const ACCELERATION_X = 5
const JUMP_VELOCITY_Y = -800
const MAX_VELOCITY = Vector2(200, 1000)
const FRICTION = Vector2(30, 0)
const GRAVITY = Vector2(0, 40)

const MIN_DISTANCE = Vector2(1, 0)
const MAX_STILL_TIME = 0.3

onready var floor_scan_left = get_node("FloorScanArea/left")
onready var floor_scan_right = get_node("FloorScanArea/right")

var key_force = Vector2(0, 0)
var was_on_floor = false

export var direction = 1

func _ready():
	body_scene = preload("res://entities/human/DeadHuman.tscn")
	next_scene = preload("res://entities/human/Zombie.tscn")
	level = 1
	respawn_time = 3
	hitpoints = 10
	
	physics.init(Vector2(ACCELERATION_X, 0), FRICTION, GRAVITY, 0, MAX_VELOCITY)

func enemy_process(delta):
	# Gibt es noch Boden?
	var direction_node
	if direction > 0:
		direction_node = floor_scan_right
	else:
		direction_node = floor_scan_left
	var floors = direction_node.get_overlapping_bodies()
	var found = false
	for f in floors:
		if f is TileMap:
			found = true
			break;
	
	# Wenn nicht, umdrehen
	if !found:
		direction = -direction
		
	# Laufe geradeaus
	key_force = Vector2(direction, 0)
	
	# Bewegung
	var position_before = position
	physics_move(physics, key_force)