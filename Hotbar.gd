extends Control

onready var hotbar = $HotbarSlots
onready var slots = hotbar.get_children()

func _ready():
	#var slots = inventory_slots.get_children()
	for i in range(slots.size()): ##每个子节点都连上 函数
		#slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	initialize_hotbar()

func initialize_hotbar():
	#var slots = inventory_slots.get_children()
	#print("数量",slots.size())
	for i in range(slots.size()): ##每个子节点都连上 函数
		if PlayerInventory.hotbar.has(i): ##initialize_item函数 有BUG 
			slots[i].initialize_item(PlayerInventory.hotbar[i][0], PlayerInventory.hotbar[i][1])
