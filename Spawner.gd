extends Node2D


var eneme_set = preload("res://Enemy//Snake.tscn")
func _ready():
	monster_generation(3)
	pass

func monster_generation(num):
	yield(get_tree().create_timer(1.0), "timeout")
	
	
	for i in range(1, num+1):
		var e1 = eneme_set.instance()
		var s ="2_"+str(i)
		e1.position = get_node(s).position
		e1.add_to_group("enemy")
		e1.set_collision_layer_bit(1,1)
		e1.set_collision_layer_bit(0,0)
		e1.set_collision_mask_bit(0,0)
		get_node("/root/Level1").add_child(e1)
		$Tween.interpolate_property(self, "modulate", Color(255,255,0,1), Color(255, 255, 0, 0), 1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
		$Tween.start()
		yield($Tween,"tween_completed")
