extends Node

const ItemClass = preload("res://Scripts/Item/Item_Script.gd")
const SlotClass = preload("res://Scripts/Inventory/slot.gd")
const WeaponClass = preload("res://Scripts/Inventory/WeaponInventory.gd")
const WeaponSlotClass = preload("res://Scripts/Inventory/WeaponSlot.gd")
const NUM_INVENTORY_SLOTS = 20

var inventory = {}

func add_item(item_name, item_quantity):
	for item in inventory:
		if item_name == inventory[item][0]:
			var stack_size = int(DataJson.item_data["item_name"]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1])
				item_quantity = item_quantity - able_to_add
		#in case item doesnt exist in the inventory yet
		else:
			for i in range(NUM_INVENTORY_SLOTS):
				if inventory.has(i) == false:
					add_item_to_empty_slot(item_name, item_quantity)
					inventory[i] = [item_name, item_quantity]
					update_slot_visual(i, inventory[i][0], inventory[i][1])
					return

func update_slot_visual(slot_index, item_name, new_quantity):
	var slot = get_tree().root.get_node("/root/Inventory/GridContainer/Slot" + (new_quantity + 1))
	if slot.item != null:
		slot.item.set_item(new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity)
		
func remove_item(slot: SlotClass):
	inventory.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
		inventory[slot.slot_index] = [item.item_name, item.item_quantity]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	inventory[slot.item_quantity] += quantity_to_add
