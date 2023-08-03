extends Panel

var slot_index := 0  #do NOT delete this, or i'll poop you 

var default_slot = preload("res://Assets/Sprites Test/singular slot.png")
var empty_slot = preload("res://Assets/Sprites Test/singular slot unused.png")
var Loot = preload("res://Scripts/Item/Ground Loot.gd")

var default_style: StyleBoxTexture = null      
var empty_style: StyleBoxTexture = null

var ItemClass = preload("res://Scenes/Item/Item.tscn")
var item = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	default_style.texture = default_slot
	empty_style.texture = empty_slot

func refresh_style():
	if item != null:
		set('custom_styles/panel', default_style)
	else:
		set('custom_styles/panel', empty_style)

func PickFromSlot():
	remove_child(item)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.add_child(item)
	item = null
	refresh_style()

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	var inventoryNode = find_parent("Inventory")
	inventoryNode.remove_child(item)
	add_child(item)
	refresh_style()

func initialize_item(item_name, item_quantity):
	if item == null:
		item = ItemClass.instance()
		add_child(item)
		item.set_item(item_name, item_quantity)
	refresh_style()
