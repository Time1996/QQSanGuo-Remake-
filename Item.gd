extends Node2D

##物品数据脚本

var item_name
var item_quantity
var item_slot

onready var userInterFace = find_parent("UserInterFace")

func _ready():
#	var name_set = jsonData.item_data.keys()
#	item_name = name_set[int(randi()%name_set.size())]
#	print(item_name)
#	item_slot = get_parent().slot_index
	$TextureRect.texture_normal = load("res://UI/item_icons/" + item_name + ".png")
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
	
	if item_quantity == 1:
		$Label.visible = false
	else:
		$Label.text = "X"+String(item_quantity)
	
func add_item_quantity(amount):
	item_quantity += amount
	$Label.text = "X"+String(item_quantity)

func sub_item_quantity(amount):
	item_quantity -= amount
	$Label.text = "X"+String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture_normal = load("res://UI/item_icons/" + item_name + ".png")
	
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = "X"+str(item_quantity)

func get_save_stats():
	item_slot = get_parent().slot_index
	print("save slot")
	print(item_slot)
	return {
		'filename' : get_filename(),
		'parent' : get_parent().get_path(),
		'data' : {
			'name' : item_name,
			'quantity' : item_quantity,
			'slot' : item_slot
		}
	}
#	var packed_scene = PackedScene.new()
#	packed_scene.pack(get_tree().get_current_scene())
#	ResourceSaver.save("res://ItemSaver.tscn", packed_scene)

func load_save_stats(stats):
	item_name = stats.data.name
	item_quantity = stats.data.quantity
	item_slot = stats.data.slot

func _on_TextureRect_mouse_entered():
	$Label2.text = item_name
	$Label2.visible = true
	pass # Replace with function body.


func _on_TextureRect_mouse_exited():
	$Label2.visible = false
	pass # Replace with function body.


func _on_TextureRect_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			if jsonData.item_data[item_name].ItemCategory == "Consumble": ##消耗品
				print(jsonData.item_data[item_name])
				find_parent("UserInterFace").get_parent().get_node("Steve").use_item(
											jsonData.item_data[item_name].AddHealth,
											jsonData.item_data[item_name].AddEnergy,
											1110,
											0
				)
			elif jsonData.item_data[item_name].ItemCategory == "Translation":
				if get_tree().get_root().has_node("bajun"):
					get_tree().get_root().get_node("bajun/Steve").position = Vector2(-16, -328)
				elif get_tree().get_root().has_node("Level1"):
					SceneChange.goto_scene("res://Scene/bajun.tscn", find_parent("Level1"))
				elif get_tree().get_root().has_node("JiangLinXiJiao"):
					SceneChange.goto_scene("res://Scene/bajun.tscn", find_parent("JiangLinXiJiao"))
					
			elif jsonData.item_data[item_name].ItemCategory == "Time":
				pass
			elif jsonData.item_data[item_name].ItemCategory == "Sword":
				pass
			
			var index = get_parent().slot_index
			PlayerInventory.inventory[index][1] -= 1
			PlayerInventory.update_slot_visual(index, 
												PlayerInventory.inventory[index][0], 
												PlayerInventory.inventory[index][1]
			)
			if item_quantity == 0:
				userInterFace.holding_item = null
				get_parent().item = null
				PlayerInventory.remove_item(get_parent())
				queue_free()
	pass # Replace with function body.
