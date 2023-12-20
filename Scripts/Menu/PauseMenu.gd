extends Control

@onready var options_menu = $OptionsMenu

var is_paused = false: set = set_is_paused

var cutscene_control
var cutscene_playing = false

func _ready() -> void:
	var tree = get_tree()
	if tree.has_group("CutsceneControl"):
		cutscene_control = tree.get_nodes_in_group("CutsceneControl")[0]
	else:
		print("No Cutscene Controller Found")

func _unhandled_input(event):
	if event.is_action_pressed("Escape"):

		handlePauseEvent()


func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeBtn_pressed():
	handlePauseEvent()


func _on_OptionsBtn_pressed():
	options_menu.visible = true


func _on_QuitBtn_pressed():
	pass
#	get_tree().quit()

func handlePauseEvent():
	if cutscene_control:
		cutscene_playing = cutscene_control.cutscene_playing
	else:
		cutscene_playing = false

	if cutscene_playing:
		cutscene_control.is_active = !cutscene_control.is_active
		visible = !cutscene_control.is_active
	else:
		self.is_paused = !is_paused
