extends Node

var scavenge = [
	{"area_id": 1, "pool": ["Scavenge_1", "Scavenge_2"]},
	{"area_id": 2, "pool": ["Scavenge_2"]},
]

var combat = [
	{"area_id": 1, "pool": []},
]	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func getCurrentScavangePool(var i):
	for area in scavenge:
		if area.area_id == i:
			return area.pool.duplicate()
	return []

func getCurrentCombatPool(var i):
	for area in combat:
		if area.area_id == i:
			return area.pool.duplicate()
	return []
