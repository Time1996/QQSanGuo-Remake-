extends Node2D

const SlotClass = preload("res://Slot.gd")
onready var inventory_slots = $ScrollContainer/VBoxContainer
var holding_item = null


func _ready():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()): ##每个子节点都连上 函数
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	initialize_inventory()


func slot_gui_input(event: InputEvent, slot: SlotClass):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			print("检测到鼠标左键按下")
			if holding_item != null:
				if !slot.item: ##空的 直接放进去
					left_click_empty_slot(slot)
				else: ##不空 先把有的存在变量里跟随鼠标 然后拿着的放进去之后 把拿着的变成本来在框里的
					if holding_item.item_name != slot.item.item_name: ## 如果不是同种物品
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif slot.item: ##已经有了 就把东西拿出来 并且跟随鼠标位置
				left_click_not_holding(slot)
				
func initialize_inventory():
	var slots = inventory_slots.get_children()
	print("数量",slots.size())
	for i in range(slots.size()): ##每个子节点都连上 函数
		if PlayerInventory.inventory.has(i): ##initialize_item函数 有BUG 
			slots[i].initialize_item(PlayerInventory.inventory[i][0], PlayerInventory.inventory[i][1])
		
func _input(event):
	if holding_item:
		holding_item.global_position = get_global_mouse_position()

func left_click_empty_slot(slot):
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	slot.putIntoSlot(holding_item)
	holding_item = null
	
func left_click_different_item(event, slot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(holding_item)
	holding_item = temp_item
	
func left_click_same_item(slot):
	var stack_size = int(jsonData.item_data[slot.item.item_name]["StackSize"])
	var able_to_add = stack_size - slot.item.item_quantity 
	if able_to_add >= holding_item.item_quantity: ##可以合并
		PlayerInventory.add_item_quantity(slot, holding_item.item_quantity)
		slot.item.add_item_quantity(holding_item.item_quantity)
		holding_item.queue_free()
		holding_item = null
	else: ##不可以合并
		if able_to_add == 0:
			left_click_different_item(holding_item, slot)
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add) ##放的地方加
			holding_item.sub_item_quantity(able_to_add) ##手里拿的减

func left_click_not_holding(slot):
	PlayerInventory.remove_item(slot)
	holding_item = slot.item
	slot.pickFromSlot()
	holding_item.global_position = get_global_mouse_position()
