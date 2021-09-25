extends CanvasLayer
var holding_item = null
onready var max_health = get_parent().get_node("Steve").max_health
onready var max_magic = get_parent().get_node("Steve").max_magic

signal health_updated()

func _input(event):
	if event.is_action_pressed("inventory"):
		$Inventory.visible = !$Inventory.visible
		$Inventory.initialize_inventory()
		
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_up()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_down()
	
	

func _ready():
	for i in get_node("Caracter/HBoxContainer").get_children():
		i.visible = false
	pass

func update_text(level, m_health, m_magic, b_damage, b_defend, b_shugong, b_shufang):
	for i in str(level).length():
		get_node("Caracter/HBoxContainer/"+str(i+1)).texture = load("res://UI/level/"+str(level).substr(i,1)+".png")
		get_node("Caracter/HBoxContainer/"+str(i+1)).visible = true
	max_health = m_health
	max_magic = m_magic
	$Inventory/Wugong.text = str(b_damage)
	$Inventory/Wufang.text = str(b_defend)
	$Inventory/Shugong.text = str(b_shugong)
	$Inventory/Shufang.text = str(b_shufang)
	
func update_inventory(m, j):
	$Inventory/Money.text = str(m)
	$Inventory/Juntuan.text = str(j)
	var cnt = 0
	for i in $Inventory/ScrollContainer/VBoxContainer.get_children():
		if i.get_children().size()!=0:
			cnt += 1
	$Inventory/Backpack.text = str(cnt) + "/50"
	
func update_exp(value):
	print("value")
	print(value)
	$exprience/TextureProgress.value = value
	$exprience/Label.text = str(value) + "%"

func _on_UserInterFace_health_updated(health, magic):
	$Caracter/Bar/HealthBar.max_value = max_health
	$Caracter/Bar/MaigcBar.max_value = max_magic
	$Caracter/Bar/HealthBar.value = health
	$Caracter/Health.text = str(health) + "/" + str(max_health)
	$Caracter/Bar/MaigcBar.value = magic
	$Caracter/Magic.text = str(magic) + "/" + str(max_magic)
	pass # Replace with function body.

#func load_save_stats(stats): #需要保存的信息 金币 物品等
	


func _on_Button_pressed():
	$Hotbar.visible = !$Hotbar.visible
	$Hotbar.initialize_hotbar()
	pass # Replace with function body.
