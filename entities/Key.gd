extends Node2D

onready var player_type = preload("res://entities/Player.gd")

func _ready():
	pass

func _process(delta):
	var collisions = get_node("Area2D").get_overlapping_bodies()
	for entity in collisions:
		if entity is player_type:
			get_parent().remove_child(self)