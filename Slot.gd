extends Panel

var default_style = null
var selected_style = null

var default_tex = preload("res://UI/player_inventory/main/67445-1.png")
var selected_tex = preload("res://UI/player_inventory/main/67445-2.png")


var item = null
var ItemClass = preload("res://Item.tscn")
var slot_index
var slot_type

enum SlotType{#第一个设置0 后面的自动递增+1
	HOTBAR = 0,
	INVENTORY,
}
func _ready():
	slot_index = int(self.name.substr(self.name.length()-1, 1))
	selected_style = StyleBoxTexture.new()
	default_style = StyleBoxTexture.new()
	
	default_style.texture = default_tex
	selected_style.texture = selected_tex
	
	var nodes = get_parent()
	
	for i in nodes.get_children(): ## 这串代码会卡 不知道为什么
		i.connect("mouse_entered", i, "mouse_enter")
		i.connect("mouse_exited", i, "mouse_exit")
	
	refresh_style()
#	styleBox.texture = preload("res://UI/21804-1.png")
#	self.hint_tooltip = "111"
	pass

func refresh_style():
	yield(get_tree(),"idle_frame")
	set('custom_styles/panel', default_style)
	

func pickFromSlot():
	print("pickFromSlot")
	if self.get_child_count() > 0:
		remove_child(item)
		var inventoryNode = find_parent("UserInterFace")
		inventoryNode.add_child(item)
		item.get_node("TextureRect").mouse_filter = MOUSE_FILTER_IGNORE
		item = null

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("UserInterFace")
	inventoryNode.remove_child(item)
	add_child(item)
	item.get_node("TextureRect").mouse_filter = MOUSE_FILTER_STOP
	#refresh_style() ##暂时不用 用了之后会导致放下后 大小不对

func initialize_item(item_name, item_quantity):
	if item == null:##有BUG 每次重新打开会
		item = ItemClass.instance()
		item.scale *= 0.75
		item.set_item(item_name, item_quantity)
		add_child(item)
	else:
		if item != null:
			item.set_item(item_name, item_quantity)
		

#func _input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == BUTTON_RIGHT && event.pressed:
#			get_parent().get_parent().get_parent().get_node("PopupMenu").popup(
#				get_global_mouse_position().x, get_global_mouse_position().y,
#				110, 110
#			)
	
func _make_custom_tooltip(for_text):
	var label = Label.new()
	var goods_data = "123"	# 物品数据
	#label.text = print(goods_data, '\t')
	return label


func mouse_enter():
	set('custom_styles/panel', selected_style)
	pass # Replace with function body.


func mouse_exit():
	set('custom_styles/panel', default_style)
	pass # Replace with function body.

func can_drop_data(position, data):
	if self.get_child_count() == 0:
		return true
	else:
		return false
	
func drop_data(position, data):
	var drag_item = load("res://Item.tscn").instance()
	drag_item.get_node("TextureRect").texture_normal = data["origin_texture"]
	drag_item.set_item(data["origin_item_name"], 1)
	drag_item.scale *= 0.75
#	drag_texture.rect_size = self.rect_size
	PlayerInventory.add_item_to_empty_slot(drag_item, self)
	add_child(drag_item)
	
