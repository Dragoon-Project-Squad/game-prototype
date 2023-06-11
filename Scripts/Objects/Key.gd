extends HiddenObject

signal key_acquired
signal key_randomPos

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func randomKeyPlacement():
	var screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y)
	self.position = Vector2(rndX, rndY)
	
func _on_KeyArea_key_acquired():
	emit_signal("key_acquired")
	print("Key acquired...")
	#Play a key pickup sound here.


func _on_Node2D_key_randomPos():
	randomKeyPlacement()
