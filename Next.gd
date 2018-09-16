extends Button

func _ready():
	pass
	
func _pressed():
	var nodes = get_tree().get_nodes_in_group("background")
	
	global.cur_level+=1
	var scene_string = "res://Level/Level"+str(global.cur_level)+".tscn"
	get_tree().change_scene(scene_string)
	
	for node in nodes:
		node.get_parent().remove_child(node)

