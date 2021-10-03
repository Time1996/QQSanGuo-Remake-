extends Node

signal active_item_updated

const NUM_INVENTORY_SLOTS = 9
const NUM_HOTBAR_SLOTS = 8

var money = 0
var juntuan = 0
var max_health = 1000
var max_magic = 1000
var basic_damage = 20
var basic_defende = 10
var basic_shugong = 0
var basic_shufang = 0
var level = 1
##背包初始内容
var inventory = {
	0 : ["回城符", 2]
#	0 : ["金疮药", 99]
}

var hotbar = {
#	0 : ["金疮药", 99]
}

var active_item_slot = 0

func add_item(item_name, item_quantity):
	for i in inventory:
		if inventory[i][0] == item_name:
			var stack_size = int(jsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[i][1]
			if able_to_add >= item_quantity:
				inventory[i][1] += item_quantity
				update_slot_visual(i, inventory[i][0], inventory[i][1])  ##更新下当前格子状态
				return
			else:
				inventory[i][1] += able_to_add	##还有剩下的去找空格子
				update_slot_visual(i, inventory[i][0], inventory[i][1])  ##更新下当前格子状态
				item_quantity -= able_to_add

	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity]
			update_slot_visual(i, inventory[i][0], inventory[i][1])
			return
			

func _ready():
	pass

func add_item_to_empty_slot(item, slot, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index] = [item.item_name, item.item_quantity]
	else:
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]
	
func remove_item(slot, is_hotbar: bool = false):
	if is_hotbar:
		hotbar.erase(slot.slot_index)
	else:
		inventory.erase(slot.slot_index)
	
func add_item_quantity(slot, quantity_to_add, is_hotbar: bool = false):
	if is_hotbar:
		hotbar[slot.slot_index][1] += quantity_to_add
	else:
		inventory[slot.slot_index][1] += quantity_to_add

func update_slot_visual(slot_index, item_name, new_quantity):
	var slot
	if get_tree().get_root().has_node("Level1"):
		slot = get_tree().get_root().get_node("Level1/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	elif get_tree().get_root().has_node("bajun"):
		slot = get_tree().get_root().get_node("bajun/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	elif get_tree().get_root().has_node("JiangLinXiJiao"):
		slot = get_tree().get_root().get_node("JiangLinXiJiao/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	
	if slot.item != null and slot.get_child_count() != 0:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func remove_all_item():
	print("clear")
	hotbar.clear()
	inventory.clear()
