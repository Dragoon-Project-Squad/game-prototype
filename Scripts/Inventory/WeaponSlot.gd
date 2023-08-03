extends Panel

const ItemClass = preload("res://Scripts/Item/Item_Script.gd")
const SlotClass = preload("res://Scripts/Inventory/slot.gd")
onready var weapon_slots = $GridContainer

func _ready():
	var slots = weapon_slots.get_children()
