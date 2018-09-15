extends Node2D

onready var collision_area = get_node("CollisionArea")
onready var player_type = preload("res://entities/Player.gd")

func _ready():
	pass

func _physics_process(delta):
	update_physics()

func update_physics():
	
	var collisions = collision_area.get_overlapping_bodies()
	for entity in collisions:
		if entity is player_type:
			global.cur_level+=1
			get_tree().change_scene("res://Level/Level"+str(global.cur_level)+".tscn")