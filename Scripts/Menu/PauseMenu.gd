extends Control

onready var restart_btn = $CenterContainer/VBoxContainer/RestartBtn
onready var options_menu = $OptionsMenu

var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("Escape"):
		self.is_paused = !is_paused

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeBtn_pressed():
	self.is_paused = false


func _on_OptionsBtn_pressed():
	options_menu.popup_centered()


func _on_QuitBtn_pressed():
	get_tree().quit()


func _on_RestartBtn_pressed():
	get_tree().change_scene("res://Scenes/Test Files/Test.tscn")
	self.is_paused = false


func _on_EndBtn_pressed():
	get_tree().change_scene("res://Scenes/Menus/MainMenu.tscn")
	self.is_paused = false
