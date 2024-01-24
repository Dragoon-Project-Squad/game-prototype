extends Node

var weapons = []

func _ready():
	load_csv("res://Resources/WeaponData/weapons.csv")

func load_csv(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	var line = file.get_line()
	line = file.get_line() #first line is for headers, this skips to second line
	
	var existing_ids = []
	while line != "":
		var values = line.split(",")
		var weapon = {
			"weapon_id" : values[0],
			"bullet_velocity" : values[1],
			"bullets_per_second" : values[2],
			"camera_shake_increment": values[3],
			"self_knockback_impulse": values[4],
			"spread_angle": values[5],
			"spread_variance": values[6],
			"bullets_per_trigger": values[7],
			"bullet_damage": values[8],
			"firing_mode": values[9]
		}
		if !existing_ids.has(weapon.weapon_id):
			existing_ids.append(weapon.weapon_id)
			weapons.append(weapon)
		line = file.get_line()
	file.close()
	print(existing_ids)
	print(weapons)

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
	return var_to_str(value)
