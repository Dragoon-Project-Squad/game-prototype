extends Area2D

var duration = 3

func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if duration > 0:
		duration -= delta
	else:
		queue_free()
