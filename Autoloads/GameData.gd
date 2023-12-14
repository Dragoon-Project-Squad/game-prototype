extends Node

var item_data = {}
var file = "res://Data/ItemData.json"
var item_stats = ["Description", "Attack", "Healing"]

func _ready():
	var item_data_string = FileAccess.get_file_as_string(file)
	var json = JSON.new()
	var error = json.parse(item_data_string, true)
	if error == OK:
		item_data = json.data
		if typeof(item_data) != TYPE_DICTIONARY:
			print("Unexpected data type for json data: ", typeof(item_data))
	else: 
		print("Something went wrong.")
	pass
