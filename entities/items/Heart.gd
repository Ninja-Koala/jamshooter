extends "res://entities/items/ItemBase.gd"

func collected(player):
	player.heal(1)
	return true