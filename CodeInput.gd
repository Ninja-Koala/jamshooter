extends LineEdit

func _ready():
	pass

func _draw():
	if has_focus():
		pass
	else:
		self.hide()
		get_node("../Code").show()

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept"):
			for i in global.level_keys.size():
				if self.text == global.level_keys[i]:
					global.cur_level = i+2
					var scene_string = "res://Level/Level"+str(global.cur_level)+".tscn"
					get_tree().change_scene(scene_string)
