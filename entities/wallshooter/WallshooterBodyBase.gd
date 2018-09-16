extends "res://entities/BodyBase.gd"

onready var content_node = get_node("Content")

var flipped = false

func _ready():
	physics.gravity = Vector2(0, 0)

func spawn_next():
	var next = .spawn_next()
	next.flipped = flipped
	return next

func flip():
	flipped = true
	var transform = content_node.get_transform()
	transform = transform.scaled(Vector2(-1, 1))
	content_node.set_transform(transform)