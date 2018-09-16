extends Node2D

const VELOCITY = 10

export var direction = Vector2(1, 0)
export var damage = 1

onready var collision_area = get_node("CollisionArea")
onready var player_type = preload("res://entities/Player.gd")

export var lifetime = 1
var remove = false

func _ready():
	pass

func _physics_process(delta):
	lifetime -= delta
	if lifetime < 0:
		get_parent().remove_child(self)
	
	update_physics()

func update_physics():
	position += VELOCITY * direction
	
	var collisions = collision_area.get_overlapping_bodies()
	if collisions.size() != 0:
		if collisions[0] is player_type:
			collisions[0].take_damage(damage)
			get_parent().remove_child(self)

	collisions = collision_area.get_overlapping_areas()

	if collisions.size() != 0:
		if collisions[0].get_parent() is player_type:
			collisions[0].get_parent().take_damage(damage)
			get_parent().remove_child(self)