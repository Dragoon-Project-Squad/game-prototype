extends Node

var inv_data = {}
var json_file_path = "user://inv_data_file.json"

var equipment_data = {"PrimWeapon1": 10003,
	"PrimWeapon2": null,
	"SecWeapon": 10001}

func _ready():
	#var inv_data_file = FileAccess.get_file_as_string(json_file_path)
	var inv_data_file = JSON.stringify(equipment_data)
	var json = JSON.new()
	var error = json.parse(inv_data_file)
	if error == OK:
		var inv_data = json.data
		if typeof(inv_data) != TYPE_DICTIONARY:
			print("Unexpected data type for json data: ", typeof(inv_data))
	else: 
		print("Something went wrong.")
	#inv_data_file.open("user://inv_data_file.json", FileAccess.READ)
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(inv_data_file.get_as_text())
	#var inv_data_json = test_json_conv.get_data()
	#inv_data_file.close()
	#inv_data = inv_data_json.result
	pass
