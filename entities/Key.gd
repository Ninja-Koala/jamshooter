extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
onready var player_type = preload("res://entities/Player.gd")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var collisions = get_node("Area2D").get_overlapping_bodies()
	for entity in collisions:
		if entity is player_type:
			get_parent().remove_child(self)
