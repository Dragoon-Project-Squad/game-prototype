extends Node2D

#0 for Closed, 1 for Open
signal door_used(oldval, newval)
var isNearDoor = false
var isOpen = false
onready var doorTiles: TileMap = $"DoorSprite"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if isNearDoor:
		if Input.is_action_just_pressed("Interact"):
			if (!isOpen):
				emit_signal("door_used", 0, 1)
				isOpen = true
				#TODO: (AUDIO) Play Door Open sounds here
				#Set Door Sprite to the open door, hardcoded
				doorTiles.set_cell(0, 0, 1)
			else:
				emit_signal("door_used", 1, 0)
				isOpen = false
				#TODO: (AUDIO) Play Door Closed sounds here
				#Set Door Sprite to the closed door, hardcoded
				doorTiles.set_cell(0, 0, 0)
			#Enable this if the door isn't refreshing 
			#doorTiles.update_dirty_quadrants()
		#else:
			#The door won't do anything.
	
func _on_DoorArea_body_entered(_body):
	isNearDoor = true


func _on_DoorArea_body_exited(_body):
	isNearDoor = false
