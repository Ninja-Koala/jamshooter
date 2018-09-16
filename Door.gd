extends Node2D

onready var collision_area = get_node("CollisionArea")
onready var player_type = preload("res://entities/Player.gd")
onready var next_level_scene = preload("res://NextLevel.tscn")
onready var won_scene = preload("res://Won.tscn")

func _ready():
	pass

func _physics_process(delta):
	update_physics()

func update_physics():
	
	var collisions = collision_area.get_overlapping_bodies()
	for entity in collisions:
		if entity is player_type:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			
			if global.cur_level+1 > global.num_levels:
				var won = won_scene.instance()
				get_node("/root").add_child(won)
			else:
				var next_level = next_level_scene.instance()
				get_node("/root").add_child(next_level)
			
			entity.get_parent().remove_child(entity)