extends "res://entities/Entity.gd"

onready var player_type = preload("res://entities/Player.gd")
onready var hit_area = get_node("HitArea")

func _ready():
	hit_area.connect("body_entered", self, "on_body_entered")

func on_body_entered(body):
	if body is player_type:
		if collected(body):
			destroy()

func collected(body):
	return true