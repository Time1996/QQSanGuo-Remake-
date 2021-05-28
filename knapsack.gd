extends TextureRect

var holding = null

func _ready():
	pass

func _input(event):
	if event is InputEventMouseButton:
		print("界面")
		if event.button_index == BUTTON_LEFT && event.pressed:
			self.set_position(get_global_mouse_position(), true)
