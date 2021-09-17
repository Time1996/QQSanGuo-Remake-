extends Panel

var default_style = null
var selected_style = null
var hotbar_style = null

var default_tex = preload("res://UI/21804-1.png")
var selected_tex = preload("res://item_slot_selected_background.png")
var hotbar_tex = preload("res://item_slot_default_background.png")

var item = null
var ItemClass = preload("res://Item.tscn")
var slot_index
var slot_type

enum SlotType{#第一个设置0 后面的自动递增+1
	HOTBAR = 0,
	INVENTORY,
}
func _ready():
	#item = ItemClass.instance()
	#item.scale = item.scale * 0.5
	#add_child(item)
	
	selected_style = StyleBoxTexture.new()
	default_style = StyleBoxTexture.new()
	hotbar_style = StyleBoxTexture.new()
	
	default_style.texture = default_tex
	selected_style.texture = selected_tex
	hotbar_style.texture = hotbar_tex
	
	refresh_style()
#	styleBox.texture = preload("res://UI/21804-1.png")
#	self.hint_tooltip = "111"
	pass

func refresh_style():
	yield(get_tree(),"idle_frame")
	if SlotType.HOTBAR == slot_type and PlayerInventory.active_item_slot == slot_index:
		set('custom_styles/panel', selected_style)
		pass
	elif SlotType.INVENTORY == slot_type:
		print(slot_type)
		set('custom_styles/panel', default_style)
		pass
	else:
		set('custom_styles/panel', hotbar_style)
		pass
	

func pickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("UserInterFace")
	inventoryNode.add_child(item)
	item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterFace")
	inventoryNode.remove_child(item)
	add_child(item)
	#refresh_style() ##暂时不用 用了之后会导致放下后 大小不对

func initialize_item(item_name, item_quantity):
	if item == null:##有BUG 每次重新打开会
		item = ItemClass.instance()
#		self.rect_size = Vector2(235, 25)
#		self.rect_min_size = Vector2(235, 25)
		item.scale *= 0.6
		item.set_item(item_name, item_quantity)
		add_child(item)
	else:
		item.set_item(item_name, item_quantity)
	#refresh_style()
	
func _make_custom_tooltip(for_text):
	var label = Label.new()
	var goods_data = "123"	# 物品数据
	#label.text = print(goods_data, '\t')
	return label
