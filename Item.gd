extends Node2D

var item_name
var item_quantity
func _ready():
	item_name = "金疮药"
	
	$TextureRect.texture = load("res://UI/item_icons/" + item_name + ".png")
	var stack_size = int(jsonData.item_data[item_name]["StackSize"])
	item_quantity = randi() % stack_size + 1
	
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

