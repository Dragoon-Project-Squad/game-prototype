extends Node

var item_data = {}
var json_file_path = "res://Data/ItemData.json"
var item_stats = ["Description", "Attack", "Healing"]

func _ready():
	#var item_data_file = FileAccess.open("res://Data/ItemData.json",FileAccess.WRITE)
	#item_data_file.open("res://Data/ItemData.json", FileAccess.READ)
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(item_data_file.get_as_text())
	#var item_data_json = test_json_conv.get_data()
	#item_data_file.close()
	#item_data = item_data_json.result
	pass
	
func readJSON(json_file_path):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = json.parse_string(content)
	return finish
