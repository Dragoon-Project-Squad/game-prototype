extends Area2D

signal key_acquired

# Called when the node enters the scene tree for the first time.
func _ready():
	#body_entered.connect(_on_body_entered(body))
	#key_acquired.connect(owner._on_key_area_key_acquired)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		key_acquired.emit()
	pass # Replace with function body.
