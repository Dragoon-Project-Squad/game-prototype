extends Interactable

@export var cutsceneResource: Resource

var cutscene_control

func _ready() -> void:
	var tree = get_tree()
	if tree.has_group("CutsceneControl"):
		cutscene_control = tree.get_nodes_in_group("CutsceneControl")[0]
	else:
		print("No Cutscene Controller Found.")

#override
func onInteract():
	if cutscene_control:
		if cutsceneResource:
			cutscene_control.loadEvents(cutsceneResource)
		else:
			print("Sign has no assinged cutscene data!")
	else:
		print("Can't play scene because no controller is found!")
