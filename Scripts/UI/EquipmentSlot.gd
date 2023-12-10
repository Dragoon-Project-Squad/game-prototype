extends TextureRect

@onready var tool_tip = preload("res://Scenes/Menus/Tooltip.tscn")

func _ready():
	connect("mouse_entered", Callable(self, "_on_Icon_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_Icon_mouse_exited"))

func _get_drag_data(_pos):
	# Retrieve information about the slot we are dragging
	var equipment_slot = get_parent().get_name()
	if PlayerData.equipment_data[equipment_slot] != null:
		var data = {}
		data["origin_node"] = self
		data["origin_panel"] = "Equipment"
		data["origin_item_id"] = PlayerData.equipment_data[equipment_slot]
		data["origin_equipment_slot"] = equipment_slot
		data["origin_stackable"] = false
		data["origin_stack"] = 1
		data["origin_texture"] = texture
	
		var drag_texture = TextureRect.new()
		drag_texture.expand = true
		drag_texture.texture = texture
		drag_texture.size = Vector2(100, 100)
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.position = -0.5 * drag_texture.size
		set_drag_preview(control)
		
		return data
	
func _can_drop_data(_pos, data):
	# Check if we can drop an item in this slot
	var target_equipment_slot = get_parent().get_name()
	if target_equipment_slot == data["origin_equipment_slot"]:
		if PlayerData.equipment_data[target_equipment_slot] == null:
			data["target_item_id"] = null
			data["target_texture"] = null
		else:
			data["target_item_id"] = PlayerData.equipment_data[target_equipment_slot]
			data["target_texture"] = texture
		return true
	else:
		return false
	
func _drop_data(_pos, data):
	# What happens when we drop an item in this slot
	var target_equipment_slot = get_parent().get_name()
	var origin_slot = data["origin_node"].get_parent().get_name()
	
	# Update the data of the origin
	if data["origin_panel"] == "Inventory":
		PlayerData.inv_data[origin_slot]["Item"] = data["target_item_id"]
	else: # Equipment
		PlayerData.equipment_data[origin_slot] = data["target_item_id"]
		
	# Update the texture of the origin
	if data["origin_panel"] == "Equipment" and data["target_item_id"] == null:
		var default_texture = load("res://Assets/Materials and Textures/" + origin_slot + "InventorySlot.png")
		data["origin_node"].texture = default_texture
	else:
		data["origin_node"].texture = data["target_texture"]
		
	# Update the texture and data of the target
	PlayerData.equipment_data[target_equipment_slot] = data["origin_item_id"]
	texture = data["origin_texture"]
	
func _on_Icon_mouse_entered():
	var tool_tip_instance = tool_tip.instance()
	tool_tip_instance.origin = "Equipment"
	tool_tip_instance.slot = get_parent().get_name()
	
	tool_tip_instance.position = get_parent().get_global_transform_with_canvas().origin + Vector2(100,0)
	
	add_child(tool_tip_instance)
	await get_tree().create_timer(0.35).timeout
	if has_node("Tooltip") and get_node("Tooltip").valid:
		get_node("Tooltip").show()
	
func _on_Icon_mouse_exited():
	get_node("Tooltip").free()
