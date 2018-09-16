extends "res://entities/BodyBase.gd"

onready var content_node = get_node("Content")

export var flipped = false

var initialized = false

func _ready():
	physics.gravity = Vector2(0, 0)

func _physics_process(delta):
	# Noch nicht initialisiert?
	if !initialized:
		initialized = true
		if flipped:
			var transform = content_node.get_transform()
			transform = transform.scaled(Vector2(-1, 1))
			content_node.set_transform(transform)
	
	._physics_process(delta)

func spawn_next():
	var next = .spawn_next()
	next.flipped = flipped
	return next