extends "res://entities/LivingEntity.gd"

onready var hit_area = get_node("HitArea")
onready var player = get_node("../../Player")
onready var navigation = get_node("../Navigation")

func _ready():
	if hit_area == null:
		hit_area = get_node("Content/HitArea")

func try_hit_player():
	if player != null:
		if hit_area != null:
			if hit_area.overlaps_body(player):
				player.take_damage(1, self)

func get_path_to_player():
	if player == null || player.get_parent() == null:
		return []
	
	var parent = get_parent()
	var path = navigation.get_simple_path(global_position, player.global_position, false)
	var result = []
	for p in path:
		result.append(p + navigation.global_position)
		
	return result

func enemy_process(delta):
	pass

func _physics_process(delta):
	if player == null || player.get_parent() == null:
		return
	
	enemy_process(delta)
	
	# Schaden
	try_hit_player()