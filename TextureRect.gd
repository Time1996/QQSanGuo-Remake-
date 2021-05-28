extends TextureButton


func get_drag_data(position):
	if has_node("Sprite"):
		var texture = TextureButton.new()
		texture.texture = $Sprite.texture
		texture.rect_scale = $Sprite.scale
		set_drag_preview(texture)
		return $Sprite
	return false
	
func can_drop_data(position, data):
	return true

func drop_data(position, data):
	if data and get_child_count()==0:
		self.add_child(data.duplicate())
		data.queue_free()
