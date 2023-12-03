extends Node

var scavenge = [
	{"area_id": 1, "pool": ["Scavenge_1", "Scavenge_2"]},
	{"area_id": 2, "pool": ["Scavenge_2"]},
]

var combat = [
	{"area_id": 1, "pool": ["Scavenge_1", "Scavenge_2"]},
	{"area_id": 2, "pool": ["Scavenge_2"]},
]	

func getCurrentScavangePool(i):
	for area in scavenge:
		if area.area_id == i:
			return area.pool.duplicate()
	return []

func getCurrentCombatPool(i):
	for area in combat:
		if area.area_id == i:
			return area.pool.duplicate()
	return []

