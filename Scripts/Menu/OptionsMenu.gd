extends Popup

# Video Settings
onready var display_options = $SettingsTab/Video/MarginContainer/VideoSettings/DisplayOptionBtn
onready var vsync_btn = $SettingsTab/Video/MarginContainer/VideoSettings/VsyncBtn
onready var display_fps_btn = $SettingsTab/Video/MarginContainer/VideoSettings/DisplayFpsBtn
onready var max_fps_val = $SettingsTab/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFpsVal
onready var max_fps_slider = $SettingsTab/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFpsSlider

# Audio Settings
onready var master_slider = $SettingsTab/Audio/MarginContainer2/AudioSettings/MasterVolSlider
onready var music_slider = $SettingsTab/Audio/MarginContainer2/AudioSettings/MusicVolSlider
onready var sfx_slider = $SettingsTab/Audio/MarginContainer2/AudioSettings/SfxVolSlider

# Gameplay Settings
onready var mouse_sens_amount = $SettingsTab/Gameplay/MarginContainer3/GameplaySettings/MouseSensOption/MouseSensAmount
onready var mouse_slider = $SettingsTab/Gameplay/MarginContainer3/GameplaySettings/MouseSensOption/MouseSensSlider


func _ready():
	pass


func _on_DisplayOptionBtn_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)


func _on_VsyncBtn_toggled(button_pressed):
	GlobalSettings.toggle_sync(button_pressed)


func _on_DisplayFpsBtn_toggled(button_pressed):
	GlobalSettings.toggle_fps_display(button_pressed)


func _on_MaxFpsSlider_value_changed(value):
	GlobalSettings.set_max_fps(value)
	max_fps_val.text = str(value) if value < max_fps_slider.max_value else "max"


func _on_MasterVolSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)


func _on_MusicVolSlider_value_changed(value):
	GlobalSettings.update_music_vol(value)


func _on_SfxVolSlider_value_changed(value):
	GlobalSettings.update_sfx_vol(value)

#TODO: Need to fix functionality
func _on_MouseSensSlider_value_changed(value):
	GlobalSettings.update_mouse_sens(value)
	mouse_sens_amount.text = str(value)
