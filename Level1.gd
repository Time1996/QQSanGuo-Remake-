extends Node2D



func _ready():
	pass



func _on_Monkey_monster_die():
	$Steve.money += 200
	print($Steve.money)
	pass # Replace with function body.


func _on_Snake_monster_die():
	$Steve.money += 100
	print("money + 100")
	print($Steve.money)
	pass # Replace with function body.


func _on_Spawner_monster_die():
	pass # Replace with function body.
