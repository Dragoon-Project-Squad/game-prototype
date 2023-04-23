extends Node

var scavenge = [
	{"area_id": 1, "pool": ["Scavenge_1", "Scavenge_2"]},
	{"area_id": 2, "pool": ["Scavenge_2"]},
]
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func getCurrentScavangePool(var i):
	for area in scavenge:
		if area.area_id == i:
			return area.pool.duplicate()
	return []
