extends Control

func _ready():
	pass


func _on_Button6_pressed():
	get_parent().get_node("SaveAndLoad").visible = !get_parent().get_node("SaveAndLoad").visible
	pass # Replace with function body.



func _on_Button2_pressed():
	get_parent().get_node("Inventory").visible = !get_parent().get_node("Inventory").visible
	print("fuck")
	pass # Replace with function body.
