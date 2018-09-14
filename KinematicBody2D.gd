extends KinematicBody2D

var a = 2
var key_force_x = 0
var key_force_y = 0
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _input(event):
	if event is InputEventKey:
		key_force_x = 0
		key_force_y = 0
		
		if Input.is_key_pressed(KEY_W):
			key_force_y -= 1
		if Input.is_key_pressed(KEY_S):
			key_force_y += 1
		
		if Input.is_key_pressed(KEY_D):
			key_force_x += 1
		if Input.is_key_pressed(KEY_A):
			key_force_x -= 1

func _process(delta):
	pass
		
func _physics_process(delta):
	print(move_and_slide(Vector2(100 * key_force_x, 100 * key_force_y), Vector2(0, -1)))
	#print(String(key_force_x) + ", " + String(key_force_y))