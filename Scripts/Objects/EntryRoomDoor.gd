extends Node2D

signal entry_door_opened
var isNearDoor = false
onready var doorTiles: TileMap = $"DoorSprite"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isNearDoor:
		if Input.is_action_just_pressed("Interact"):
			emit_signal("entry_door_opened")
			#TODO: (AUDIO) Play Door sounds here
			get_node("DoorArea/DoorCollision").queue_free()
			#Set Door Sprite to the open door, hardcoded
			doorTiles.set_cell(0, 0, 1)
			#Enable this if the door isn't refreshing 
			#doorTiles.update_dirty_quadrants()
		#else:
			#The door won't do anything.
	
func _on_DoorArea_body_entered(_body):
	isNearDoor = true


func _on_DoorArea_body_exited(_body):
	isNearDoor = false
