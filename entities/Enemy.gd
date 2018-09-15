extends "res://entities/LivingEntity.gd"

onready var hit_area = get_node("HitArea")
onready var player = get_node("../../Player")
onready var navigation = get_node("../Navigation")

func try_hit_player():
	if hit_area != null:
		if hit_area.overlaps_body(player):
			player.take_damage(1, self)

func get_path_to_player():
	var parent = get_parent()
	var path = navigation.get_simple_path(global_position, player.global_position, false)
	var result = []
	for p in path:
		result.append(p + navigation.global_position)
		
	return result