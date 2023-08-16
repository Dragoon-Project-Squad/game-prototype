extends HiddenObject
class_name Interactable

export (NodePath) onready var highlight = get_node(highlight)

var is_in_range = false

func _process(delta: float) -> void:
	pass

func _ready() -> void:
	highlight.visible = false

func onInteract():
	print("Interact for this object hasn't been implemented!")

func setHighlight(visible: bool):
	highlight.visible = visible

func _on_Player_Detection_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		body.get_parent().addToInteractList(self);


func _on_Player_Detection_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		setHighlight(false)
		body.get_parent().removeFromInteractList(self);
