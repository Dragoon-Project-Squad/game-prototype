extends Node

export(String, FILE) var level

onready var play_btn = $CenterContainer/VBoxContainer/MarginContainer/MenuBtns/PlayBtn
onready var options_menu = $OptionsMenu

func _ready():
	play_btn.grab_focus()


func _on_PlayBtn_pressed():
	get_tree().change_scene("res://Scenes/Test Files/Test.tscn")


func _on_OptionsBtn_pressed():
	options_menu.popup_centered()
