extends TextureButton


func _ready():
	pass
	
func get_drag_data(position):
	var data = {}
	data["origin_texture"] = self.texture_normal
	data["origin_item_name"] = "铁剑"
	var drag_texture = TextureRect.new()
	drag_texture.texture = self.texture_normal
	drag_texture.rect_size = self.rect_size
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	
	set_drag_preview(control)
	return data
