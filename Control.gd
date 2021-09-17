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
	pass


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
