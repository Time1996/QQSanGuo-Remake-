extends Control

func _ready():
	pass


func _on_Button6_pressed():
	get_parent().get_node("SaveAndLoad").visible = !get_parent().get_node("SaveAndLoad").visible
	pass # Replace with function body.



func _on_Button2_pressed():
	get_parent().get_node("Inventory").visible = !get_parent().get_node("Inventory").visible
	pass # Replace with function body.


func _on_Button_pressed():
	get_parent().get_node("player_state").visible = !get_parent().get_node("player_state").visible
	pass # Replace with function body.


func _on_Button3_pressed():
	get_parent().get_node("player_skill").visible = !get_parent().get_node("player_skill").visible
	pass # Replace with function body.


func _on_Button5_pressed():
	get_parent().get_node("player_task").visible = !get_parent().get_node("player_task").visible
	pass # Replace with function body.
