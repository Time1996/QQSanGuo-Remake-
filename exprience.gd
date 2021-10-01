extends Control

onready var steve = get_tree().get_root().get_node("Level1/Steve")

func _ready():
	pass


func _on_shortcut2_pressed():
	steve.key_state = "S"
	steve.attack()
	print("S")
	pass # Replace with function body.


func _on_shortcut1_pressed():
	steve.key_state = "A"
	steve.attack()
	print("A")
	pass # Replace with function body.


func _on_shortcut3_pressed():
	steve.key_state = "D"
	steve.attack()
	print("D")
	pass # Replace with function body.


func _on_shortcut4_pressed():
	steve.key_state = "F"
	print("F")
	pass # Replace with function body.


func _on_shortcut5_pressed():
	steve.key_state = "Q"
	print("Q")
	pass # Replace with function body.


func _on_shortcut6_pressed():
	steve.key_state = "W"
	steve.attack()
	print("W")
	pass # Replace with function body.


func _on_shortcut7_pressed():
	steve.key_state = "E"
	print("E")
	pass # Replace with function body.


func _on_shortcut8_pressed():
	steve.key_state = "R"
	print("R")
	pass # Replace with function body.
