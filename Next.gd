extends Button

func _ready():
	pass
	
func _pressed():
	var nodes = get_tree().get_nodes_in_group("background")
	
	global.cur_level+=1
	get_tree().change_scene("res://Level/Level"+str(global.cur_level)+".tscn")
	
	for node in nodes:
		node.get_parent().remove_child(node)

