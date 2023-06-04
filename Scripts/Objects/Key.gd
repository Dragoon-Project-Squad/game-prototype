extends HiddenObject

signal key_acquired

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_KeyArea_key_acquired():
	emit_signal("key_acquired")
	print("Key acquired...")
	#Play a key pickup sound here.
