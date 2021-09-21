extends Node

var save_filename = "user://save_game.save"

func _ready():
	pass

func save_game():
	var save_file = File.new()
	save_file.open(save_filename, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	
	for node in save_nodes:
		if node.filename.empty():
			break
			
		var node_details = node.get_save_stats()
		save_file.store_line(to_json(node_details))
		
	save_file.close()

func load_game():
	
	var save_file = File.new()
	if not save_file.file_exists(save_filename):
		return
	
	var saved_nodes = get_tree().get_nodes_in_group("Persist")
	
#	for node in saved_nodes:
#		node.queue_free()
		
	save_file.open(save_filename, File.READ)
	get_tree().change_scene("res://Leve1.tscn")
	
	#等场景加载好了再执行下面的内容
	yield(get_tree().create_timer(1.0),"timeout")
	
	PlayerInventory.remove_all_item()
	var inv_slots = get_tree().get_root().get_node("Level1").get_node("UserInterFace").get_node('Inventory').inventory_slots
	var hot_slots = get_tree().get_root().get_node("Level1").get_node("UserInterFace").get_node('Hotbar').slots
	
	print(PlayerInventory.hotbar)
	print(PlayerInventory.inventory)
	
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		print(node_data)
		print(node_data.size())
#		var new_obj = load(node_data.filename).instance()
#		get_node(node_data.parent).call_deferred('add_child', new_obj)
		if node_data.filename == "res://Character/Steve.tscn":
			get_node("/root/Level1/Steve").load_save_stats(node_data) ##人物信息加载 node_data里面各取所需
		elif node_data.filename == "res://Item.tscn":
			var item = load("res://Item.tscn").instance()
			item.load_save_stats(node_data)
			item.scale *= 0.6
			item.add_to_group("Persist")

			var type_name = node_data.parent
			var inv_or_hot = type_name.substr(type_name.length()-2, 1)
			
			
			print(inv_or_hot)
			if inv_or_hot == 'l':#背包
				print('backpack')
				PlayerInventory.add_item_to_empty_slot(item, get_node(node_data.parent), false)
			else:				#快捷栏
				PlayerInventory.add_item_to_empty_slot(item, get_node(node_data.parent), true)
				get_tree().get_root().get_node("Level1").get_node("UserInterFace").get_node("Hotbar").initialize_hotbar()
			print(PlayerInventory.hotbar)
			print(PlayerInventory.inventory)
	save_file.close()
