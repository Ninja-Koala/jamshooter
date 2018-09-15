extends Node2D

const VELOCITY = 40

export var direction = Vector2(1, 0)

export var hooked = false
export var pull_strength = 400

var enemy_type = preload("res://entities/Enemy.gd")

onready var player = get_node("../Player")

func _ready():
	pass

func _physics_process(delta):
	update_physics()

func update_physics():
	if not hooked:
		var collision = move_and_collide(VELOCITY * direction)
		if collision:
			var entity = collision.collider
			if entity.get_class() == "TileMap":
				var pos = collision.position - collision.normal*16 - entity.global_position
				var tile_pos=pos/64
				
				var tile_x = floor(tile_pos.x)
				var tile_y = floor(tile_pos.y)
					
				var cur_cell = entity.get_cell(tile_x,tile_y)
				var cell_name = entity.tile_set.tile_get_name(cur_cell)
				if cell_name == "Wall":
					hooked = true
					position -= collision.normal * 16
					return
				elif cell_name == "Unhookable Wall":
					player.remove_hook()
			else:
				player.remove_hook()
