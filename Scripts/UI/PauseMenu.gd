extends CanvasLayer

var cutscene_playing = false
var cutscene_control

func _ready() -> void:
	visible = false
	var tree = get_tree()
	if tree.has_group("CutsceneControl"):
		cutscene_control = tree.get_nodes_in_group("CutsceneControl")[0]
	else:
		print("No Cutscene Controller Found.")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if cutscene_control:
			cutscene_playing = cutscene_control.cutscene_playing
		else:
			cutscene_playing = false
		
		if cutscene_playing:
			cutscene_control.is_active = !cutscene_control.is_active
			visible = !cutscene_control.is_active
		else:
			get_tree().paused = !get_tree().paused
			visible = get_tree().paused
