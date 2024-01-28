extends GenericLevelScript

signal key_random_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	key_random_pos.emit()
