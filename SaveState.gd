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
	while save_file.get_position() < save_file.get_len():
		var node_data = parse_json(save_file.get_line())
		print(node_data)
		print(node_data.size())
#		var new_obj = load(node_data.filename).instance()
#		get_node(node_data.parent).call_deferred('add_child', new_obj)
		get_tree().change_scene("res://Leve1.tscn")
		if node_data.filename == "res://Character/Steve.tscn":
			get_node("/root/Level1/Steve").load_save_stats(node_data) ##人物信息加载 node_data里面各取所需
		else:
			var item = load("res://Item.tscn").instance()
			item.load_save_stats(node_data)
			get_node(node_data.parent).add_child(item) ##库存信息加载
	
	save_file.close()
