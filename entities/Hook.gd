extends Node2D

const VELOCITY = 40

export var direction = Vector2(1, 0)

export var hooked = false

export var pull_strength = 400

onready var collision_area = get_node("CollisionArea")
onready var enemy_type = preload("res://entities/Enemy.gd")

onready var player_type = preload("res://entities/Player.gd")


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	
	update_physics()

func update_physics():
	if not hooked:
		position += VELOCITY * direction
		var collisions = collision_area.get_overlapping_bodies()
		if collisions.size() != 0:
			for entity in collisions:
				if entity.get_class() == "TileMap":
					var cur_cell=entity.get_cellv(self.global_position/64-entity.global_position)
					var cell_name = entity.tile_set.tile_get_name(cur_cell)
					if cell_name == "Wall":
						hooked = true
					elif cell_name == "Unhookable Wall":
						get_parent().remove_child(self)