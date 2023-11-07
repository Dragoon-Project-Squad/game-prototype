extends Node2D
class_name DragoonGameDoor
#0 for Closed, 1 for Open
signal door_used(oldval, newval)
var isNearDoor = false
var isOpen = false
@onready var doorTiles: TileMap = $"DoorSprite"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if isNearDoor:
		if Input.is_action_just_pressed("Interact"):
			if (!self.isOpen):
				emit_signal("door_used", 0, 1)
				self.isOpen = true
				#TODO: (AUDIO) Play Door Open sounds here
				#Set Door Sprite to the open door, hardcoded
				doorTiles.set_cell(0, Vector2.ZERO, 1, Vector2i.ZERO)
			else:
				emit_signal("door_used", 1, 0)
				self.isOpen = false
				#TODO: (AUDIO) Play Door Closed sounds here
				#Set Door Sprite to the closed door, hardcoded
				doorTiles.set_cell(0, Vector2.ZERO, 0, Vector2i.ZERO)
			#Enable this if the door isn't refreshing 
			#doorTiles.update_dirty_quadrants()
		#else:
			#The door won't do anything.
	
func _on_DoorArea_body_entered(_body):
	if _body.is_in_group("Player"):
		self.isNearDoor = true


func _on_DoorArea_body_exited(_body):
	if _body.is_in_group("Player"):
		self.isNearDoor = false
