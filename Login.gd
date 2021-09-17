extends Control
var level = load("res://Level1.tscn")

func _ready():
	pass


func _on_Exit_pressed():
	queue_free()
	get_tree().quit()
	pass # Replace with function body.


func _on_Login_pressed():
	queue_free()
	get_tree().change_scene_to(level)
	pass # Replace with function body.


func _on_Load_pressed():
	print("load")
	get_tree().change_scene_to(level)
	SaveState.load_game()
	pass # Replace with function body.
