extends Control

# Read game_data dictionary
@onready var game_data = GlobalSettings.game_data

# Video Settings
@onready var display_options = $SettingsTab/Video/MarginContainer/VideoSettings/ScreenModeBtn
@onready var res_opts = $SettingsTab/Video/MarginContainer/VideoSettings/ResBtn
@onready var vsync_btn = $SettingsTab/Video/MarginContainer/VideoSettings/VsyncBtn
@onready var display_fps_btn = $SettingsTab/Video/MarginContainer/VideoSettings/DisplayFpsBtn
@onready var max_fps_val = $SettingsTab/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFpsVal
@onready var max_fps_slider = $SettingsTab/Video/MarginContainer/VideoSettings/HBoxContainer/MaxFpsSlider

# Audio Settings
@onready var master_slider = $SettingsTab/Audio/MarginContainer2/AudioSettings/MasterVolSlider
@onready var master_vol_txt = $SettingsTab/Audio/MarginContainer2/AudioSettings/MasterVolLabel
@onready var master_mute = false
@onready var music_slider = $SettingsTab/Audio/MarginContainer2/AudioSettings/MusicVolSlider
@onready var music_vol_txt = $SettingsTab/Audio/MarginContainer2/AudioSettings/MusicVolLabel
@onready var music_mute = false
@onready var sfx_slider = $SettingsTab/Audio/MarginContainer2/AudioSettings/SfxVolSlider
@onready var sfx_vol_txt = $SettingsTab/Audio/MarginContainer2/AudioSettings/SfxVolLabel
@onready var sfx_mute = false

# Gameplay Settings
@onready var mouse_sens_amount = $SettingsTab/Gameplay/MarginContainer3/GameplaySettings/MouseSensOption/MouseSensAmount
@onready var mouse_slider = $SettingsTab/Gameplay/MarginContainer3/GameplaySettings/MouseSensOption/MouseSensSlider


# Testing resolution list
var resolutions: Dictionary = {
	"3840x2160":Vector2i(3840,2160),
	"2560x1440":Vector2i(2560,1440),
	"1920x1080":Vector2i(1920,1080),
	"1600x900":Vector2i(1600,900),
	"1440x900":Vector2i(1440,900),
	"1536x864":Vector2i(1536,864),
	"1366x768":Vector2i(1366,768),
	"1280x720":Vector2i(1280,720),
	"1024x600":Vector2i(1024,600),
	"800x600":Vector2i(800,600)
	}

func _ready() -> void:
	add_resolutions()
	display_options.selected = game_data.fullscreen_mode
	max_fps_slider.value = game_data.max_fps
	master_slider.value = game_data.master_vol
	music_slider.value = game_data.music_vol
	sfx_slider.value = game_data.sfx_vol
	mouse_slider.value = game_data.mouse_sens

func add_resolutions():
	var CurrentResolution = get_viewport().get_size()
	var Index = -1

	for r in resolutions:
		res_opts.add_item(r,Index)
		if resolutions[r] == CurrentResolution:
			res_opts._select_int(Index)
		Index += 1


func _on_DisplayOptionBtn_item_selected(index):
	GlobalSettings.toggle_fullscreen(index)


func _on_VsyncBtn_toggled(button_pressed):
	GlobalSettings.toggle_sync(button_pressed)


func _on_DisplayFpsBtn_toggled(button_pressed):
	GlobalSettings.toggle_fps_display(button_pressed)


func _on_MaxFpsSlider_value_changed(value):
	GlobalSettings.set_max_fps(value)
	max_fps_val.text = str(value) if value < max_fps_slider.max_value else "max"


func _on_MasterVolSlider_value_changed(value):
	GlobalSettings.update_master_vol(value)
	var percent = value * 100
	master_vol_txt.text = ("Master volume %.0f" % percent)


func _on_MusicVolSlider_value_changed(value):
	GlobalSettings.update_music_vol(value)
	var percent = value * 100
	music_vol_txt.text = ("Music volume %.0f" % percent)


func _on_SfxVolSlider_value_changed(value):
	GlobalSettings.update_sfx_vol(value)
	var percent = value * 100
	sfx_vol_txt.text = ("SFX volume %.0f" % percent)

#TODO: Need to fix functionality
func _on_MouseSensSlider_value_changed(value):
	GlobalSettings.update_mouse_sens(value)
	mouse_sens_amount.text = str(value)


func _on_close_btn_pressed() -> void:
	visible = false


func _on_res_btn_item_selected(index: int) -> void:
	GlobalSettings.update_resolution(resolutions.values()[index])
	DisplayServer.window_set_size(resolutions.values()[index])
