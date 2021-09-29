extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 300
var velocity = Vector2.ZERO
var item_name

var player = null
var being_picked_up = false


func _ready():
	randomize()
	var name_set = jsonData.item_data.keys()
	item_name = name_set[int(randi()%name_set.size())]
	$Sprite.animation = item_name
	print(item_name)
	#if randi() % 2 == 0:
	#	item_name = "铁剑"
	#else:
#	item_name = "金疮药"

func _physics_process(delta): ##物理效果
	if being_picked_up == false:
		velocity = velocity.move_toward(Vector2(0, MAX_SPEED), ACCELERATION * delta)
	else:
		var dir = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(dir * MAX_SPEED , ACCELERATION * delta)
		
		var dist = global_position.distance_to(player.global_position)
		if dist < 5:
			##if item is effect:
#			player.gain_speed()
			##else:
			PlayerInventory.add_item(item_name, 1) ##加入包里
			queue_free()
		
	velocity = move_and_slide(velocity, Vector2.UP)
	 
func pick_up_item(body):
	player = body
	being_picked_up = true
