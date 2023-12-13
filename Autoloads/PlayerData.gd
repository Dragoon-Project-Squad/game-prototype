extends Node

var inv_data = {}
var json_file_path = "user://inv_data_file.json"

var equipment_data = {"PrimWeapon1": 10003,
	"PrimWeapon2": null,
	"SecWeapon": 10001}

func _ready():
	#var inv_data_file = FileAccess.open("user://inv_data_file.json",FileAccess.WRITE)
	#inv_data_file.open("user://inv_data_file.json", FileAccess.READ)
	#var test_json_conv = JSON.new()
	#test_json_conv.parse(inv_data_file.get_as_text())
	#var inv_data_json = test_json_conv.get_data()
	#inv_data_file.close()
	#inv_data = inv_data_json.result
	pass
	
func readJSON(aJSONFilePath):
	var file = FileAccess.open(json_file_path, FileAccess.READ)
	var content = file.get_as_text()
	var json = JSON.new()
	var finish = JSON.parse_string(content)
	return finish
