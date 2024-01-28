extends Node

var weapons = []
var weapon_ids = []

func _ready():
	load_csv("res://Resources/WeaponData/weapons.csv")

func load_csv(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	var line = file.get_line()
	line = file.get_line() #first line is for headers, this skips to second line
	
	
	while line != "":
		var values = line.split(",")
		var weapon = {
			"weapon_id" : convert_value(values[0]),
			"bullet_velocity" : convert_value(values[1]),
			"bullets_per_second" : convert_value(values[2]),
			"camera_shake_increment": convert_value(values[3]),
			"self_knockback_impulse": convert_value(values[4]),
			"spread_angle": convert_value(values[5]),
			"spread_variance": convert_value(values[6]),
			"bullets_per_trigger": convert_value(values[7]),
			"bullet_damage": convert_value(values[8]),
			"firing_mode": convert_value(values[9])
		}
		if !weapon_ids.has(weapon.weapon_id):
			weapon_ids.append(weapon.weapon_id)
			weapons.append(weapon)
		line = file.get_line()
	file.close()

func convert_value(value):
	# Try converting to integer
	if value.is_valid_int():
		return int(value)
	# Try converting to float
	if value.is_valid_float():
		return float(value)
	# Try converting to boolean
	if value.to_lower() == "true":
		return true
	elif value.to_lower() == "false":
		return false
	# Fallback to string
	return value
