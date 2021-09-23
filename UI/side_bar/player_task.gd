extends Control


func _ready():
	pass


func _on_TextureButton7_pressed():
	self.visible = !self.visible
	pass # Replace with function body.


func _on_TextureButton5_pressed():
	self.visible = !self.visible
	pass # Replace with function body.


func _on_TextureButton_pressed():
	$current_task.visible = true
	$main_task.visible = false
	$remain_task.visible = false
	pass # Replace with function body.


func _on_TextureButton2_pressed():
	$current_task.visible = false
	$main_task.visible = true
	$remain_task.visible = false
	pass # Replace with function body.


func _on_TextureButton3_pressed():
	$current_task.visible = false
	$main_task.visible = false
	$remain_task.visible = true
	pass # Replace with function body.
