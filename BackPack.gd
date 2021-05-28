extends TextureRect

func get_drag_data(position):
	var Contorl = self.duplicate()
	print("YEs")
	var posi = get_global_mouse_position()
	Contorl.rect_position = posi
	print(Contorl.rect_position)
	set_drag_preview(Contorl)
	return Contorl
	

func _ready():
	pass
