extends Control

var drag_position = null

onready var backpack = get_parent().get_node("Inventory/ScrollContainer")


func _ready():
	add_child(backpack)
	self.visible = false
	pass

func refresh():
	print("refresh")
	var a = 0
	var b = 0
	for i in $ScrollContainer/VBoxContainer.get_children():
		b = 0
		for j in find_parent("UserInterFace").get_node("Inventory/ScrollContainer/VBoxContainer").get_children():
			if a==0 and b==0: 
				if j.get_child_count() > 0:
					print(j.get_child(0))
					i.get_child(0).texture_normal = j.get_child(0).get_child(0).texture_normal
					print(i)
				break
			b += 1
		a += 1
	
func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			drag_position = get_global_mouse_position() - rect_global_position
		else:
			drag_position = null
			
	if event is InputEventMouseMotion and drag_position:
		rect_global_position = get_global_mouse_position() - drag_position
	pass # Replace with function body.


func _on_TextureButton6_pressed():
	self.visible = false
	pass # Replace with function body.
