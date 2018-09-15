extends "res://entities/Entity.gd"

onready var hit_area = get_node("HitArea")
onready var player = get_parent().get_node("Player")

func _ready():
	pass

func try_hit_player():
	if hit_area != null:
		if hit_area.overlaps_body(player):
			player.take_damage(1)

func get_path():
	return get_node("../Environment/Navigation").get_simple_path(global_position, player.global_position, false)