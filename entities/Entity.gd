extends KinematicBody2D

export var hitpoints = 1

func take_damage(damage):
	print("ow!")
	hitpoints -= damage
	if hitpoints <= 0:
		die()

func die():
	pass

func destroy():
	get_parent().remove_child(self)