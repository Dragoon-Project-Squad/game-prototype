extends Node2D

var data

var item_name
var item_quantity

func _ready():
	var rand_val = randi()%2
	if rand_val == 0:
		item_name = "Copium tank"
	elif rand_val == 1:
		item_name = "Deez Nuts jar"
	
	$TextureRect.texture = load("res://Assets/Sprites Test/"+item_name+".jpg")
	var stack_size = int(DataJson.item_data[item_name]["StackSize"])
	item_quantity = randi()%stack_size + 1
	
	if stack_size == 1:
		$Label.text = str(item_name)
	else:
		$Label.text = int(item_quantity)

func set_item(nm, qnt):
	item_name = nm
	item_quantity = qnt
	$TextureRect.texture = load("res://Assets/Sprites Test/"+item_name+".jpg")
	
	var stack_size = int(DataJson.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.text = str(item_name)
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)
