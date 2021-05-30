extends Node

signal active_item_updated

const NUM_INVENTORY_SLOTS = 20
const NUM_HOTBAR_SLOTS = 8

##背包初始内容
var inventory = {
	0 : ["金疮药", 99]
}

var hotbar = {
	0 : ["金疮药", 99]
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
	var slot = get_tree().root.get_node("/root/Level1/UserInterFace/Inventory/ScrollContainer/VBoxContainer/Panel" + str(slot_index + 1))
	#print(slot.name)
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)

func active_item_scroll_down():
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS #向右移动
	print(active_item_slot)
	emit_signal("active_item_updated")
	
func active_item_scroll_up():
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	print(active_item_slot)
	emit_signal("active_item_updated")
