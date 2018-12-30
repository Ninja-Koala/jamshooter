extends Button

func _ready():
	pass

func _pressed():
	get_node("../CodeInput").show()
	get_node("../CodeInput").grab_focus()
	self.hide()
