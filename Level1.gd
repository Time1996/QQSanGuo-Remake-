extends Node2D



func _ready():
	pass



func _on_Monkey_monster_die():
	$Steve.money += 200
	$Steve.gain_experience(2)
	get_node("Steve/AnimationPlayer").play("experience")
	print("experience + 2")
	print("money + 200")
	print($Steve.money)
	pass # Replace with function body.


func _on_Snake_monster_die():
	$Steve.money += 100
	$Steve.gain_experience(1)
	get_node("Steve/AnimationPlayer").play("experience")
	print("experience + 1")
	print("money + 100")
	print($Steve.money)
	pass # Replace with function body.


func _on_Spawner_monster_die():
	pass # Replace with function body.


func _on_TransPort_body_entered(body):
	pass # Replace with function body.


func _on_Timer_timeout():#auto generation
	var nodes = get_tree().get_nodes_in_group("enemy").size()
	if nodes < 10:
		$Spawner_Snake.monster_generation(10-nodes)
	pass # Replace with function body.
