extends Node2D

onready var collision_area = get_node("CollisionArea")
onready var player_type = preload("res://entities/Player.gd")

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	# Called every frame. Delta is time since last frame.
	# Update game logic here.
	update_physics()

func update_physics():
	
	var collisions = collision_area.get_overlapping_bodies()
	for entity in collisions:
		if entity is player_type:
			print("Victory")