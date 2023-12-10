extends Node

<<<<<<< Updated upstream
@export_file var level # (String, FILE)
=======
@export var level # (String, FILE)
>>>>>>> Stashed changes

@onready var play_btn = $CenterContainer/VBoxContainer/MarginContainer/MenuBtns/PlayBtn
@onready var options_menu = $OptionsMenu

func _ready():
	play_btn.grab_focus()


func _on_PlayBtn_pressed():
	get_tree().change_scene_to_file("res://Scenes/Test Files/Test.tscn")


func _on_OptionsBtn_pressed():
	options_menu.popup_centered()
