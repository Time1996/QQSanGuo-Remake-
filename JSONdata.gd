extends Node

var item_data: Dictionary

func _ready():
	item_data = LoadData("res://Data/itemData.json") ##读取json数据 放入godot字典里 来使用数据
	pass
	
func LoadData(file_path):
	var json_data
	var file_data = File.new()
	
	file_data.open(file_path, File.READ)
	json_data = JSON.parse(file_data.get_as_text())
	print(json_data)
	file_data.close()
	return json_data.result
