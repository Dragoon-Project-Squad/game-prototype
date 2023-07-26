extends CanvasLayer

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
