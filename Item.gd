extends Node2D

##物品数据脚本

var item_name
var item_quantity
var item_slot
func _ready():
	item_name = "金疮药"
#	item_slot = get_parent().slot_index
	print(item_name)
	print("item_slot")
	print(item_slot)
	$TextureRect.texture = load("res://UI/item_icons/" + item_name + ".png")
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
#	item_quantity = randi() % stack_size + 1
	
	if item_quantity == 1:
		$Label.visible = false
	else:
		$Label.text = String(item_quantity)
	
func add_item_quantity(amount):
	item_quantity += amount
	$Label.text = String(item_quantity)

func sub_item_quantity(amount):
	item_quantity -= amount
	$Label.text = String(item_quantity)

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://UI/item_icons/" + item_name + ".png")
	
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = str(item_quantity)

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
