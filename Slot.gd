extends Panel


var styleBox = null
var item = null
var ItemClass = preload("res://Item.tscn")
var slot_index

func _ready():
	#item = ItemClass.instance()
	#item.scale = item.scale * 0.5
	#add_child(item)
	styleBox = StyleBoxTexture.new()
	styleBox.texture = preload("res://UI/21804-1.png")
	self.hint_tooltip = "111"
	pass

func refresh_style():
	set("custom_styles/panel", styleBox)
	self.rect_size = Vector2(235, 25)
	self.rect_min_size = Vector2(235, 25)

func pickFromSlot():
	print("拉起")
	remove_child(item)
	var inventoryNode = get_parent()
	inventoryNode.add_child(item)
	item = null

func putIntoSlot(new_item):
	print("放下")
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = get_parent()
	inventoryNode.remove_child(item)
	add_child(item)
	#refresh_style() ##暂时不用 用了之后会导致放下后 大小不对

func initialize_item(item_name, item_quantity):
	if item == null:##有BUG 每次重新打开会
		print("新物品增加")
		item = ItemClass.instance()
		item.scale *= 0.5
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
