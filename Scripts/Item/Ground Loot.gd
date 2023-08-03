extends Area2D

onready var PlayerMain = load("res://Scripts/Player/PlayerMain.gd")
onready var PickupZone = load("res://Scripts/Player/PickupZone.gd").new()
const acceleration = 100
const max_speed = 40
var velocity = Vector2.ZERO
var item_name
var item_quantity
var StackSize
var player = null
var being_picked_up = false
var allow = false

var items_in_range = {}

func _ready():
	item_name = "Copium Tank"
	item_quantity = 1


func _physics_process(delta):
		if Input.is_action_just_pressed("Pickup"):
			pick_up_item(item_name)
			PlayerInventory.add_item(item_name, item_quantity)
			get_parent().remove_child(self)
		else:
			velocity = velocity.move_toward(Vector2(0, max_speed), acceleration * delta)

func pick_up_item(body):
	player = body
	being_picked_up = true

#I know this looks messed up, idk what i did, but it works. If i either delete the code in this
#func or in physcics process, the loot won't dissapear
func _on_PickupZone_tru(body: Node) -> void:
	if ! body.is_in_group("Item") || ! body.is_in_group("Player"):
		if Input.is_action_just_pressed("Pickup"):
			pick_up_item(item_name)
			PlayerInventory.add_item(item_name, item_quantity)	
			get_parent().queue_free()
