extends "res://entities/Enemy.gd"

var body_scene
var next_scene
onready var next_level = level + 1
var respawn_time = 3.402823e+38

export var level = 0

func die():
	# Spawne die Leiche
	if body_scene != null:
		spawn_body()
	
	# Entferne mich
	destroy()

func spawn_body():
	var body = body_scene.instance()
	get_parent().add_child(body)
	body.position = position
	body.init(next_level, next_scene, respawn_time)
	return body