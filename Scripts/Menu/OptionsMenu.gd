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

# Control settings
@onready var input_list = $SettingsTab/Controls/MarginContainer/Inputs/ScrollContainer/VBoxContainer
@onready var change_popup = $ChangeKey
var action_name: String = ""
var input_index: int = 0

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

var inputs: Array = []
var input_dict: Dictionary = {}

func _ready() -> void:
	change_popup.visible = false
	add_inputs()
	add_resolutions()
	display_options.selected = game_data.fullscreen_mode
	max_fps_slider.value = game_data.max_fps
	master_slider.value = game_data.master_vol
	music_slider.value = game_data.music_vol
	sfx_slider.value = game_data.sfx_vol
	mouse_slider.value = game_data.mouse_sens

func add_inputs():
	InputMap.load_from_project_settings()
	var filteredInputs = []

	for action in InputMap.get_actions():
		if action.left(2) != "ui":
			var inputEvents = InputMap.action_get_events(action)

			var inputEventsProcessed = []
			for inputEvent in inputEvents:
				var processedEvent = null
				if inputEvent is InputEventMouseButton or inputEvent is InputEventJoypadButton:
					processedEvent = inputEvent.button_index
				elif inputEvent is InputEventKey:
					processedEvent = OS.get_keycode_string(inputEvent.keycode)
				elif inputEvent is InputEventJoypadMotion:
					processedEvent = inputEvent.axis
				inputEventsProcessed.append(processedEvent)
#				print(processedEvent)
			input_dict[action] = inputEventsProcessed
	create_controls()

# Without using some plugin or defining custom control nodes this is going to look messy
# There's a lot to configure and it needs to be done right!
func create_controls():
	for key in input_dict.keys():

		var action = Label.new()
		action.text = str(key)
		action.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		action.size_flags_vertical += SIZE_FILL
		action.size_flags_horizontal += SIZE_EXPAND

		var hbox = HBoxContainer.new()
		var vbox = VBoxContainer.new()
		vbox.size_flags_horizontal += SIZE_EXPAND

		for value in input_dict[key]:
			print(input_dict[key].find(value))
			var input = Button.new()
			input.text = str(value)
#			print(value)
			input.pressed.connect(_on_button_pressed.bind(input, action, input_dict[key]))
			vbox.add_child(input)

		var add_input = Button.new()
		add_input.text = "+"
		add_input.pressed.connect(_on_button_pressed.bind(add_input, action))
		vbox.add_child(add_input)
		hbox.add_child(action)
		hbox.add_child(vbox)
		input_list.add_child(hbox)

func _on_button_pressed(value, action):
	print(str(value.text) +  " " + str(action.text))
	change_popup.visible = true
	change_popup.anchors_preset = PRESET_CENTER
	change_popup.get_child(0).text = "%s is currently set to %s \n Please enter new input" % [value.text, action.text]
	action_name = str(action)
	input_index = action
	print(input_index)
	change_input(value, action)

func _unhandled_input(event: InputEvent) -> void:
	if change_popup.visible == true:
		if (event is InputEventKey or event is InputEventMouseButton) and event.is_pressed():
			accept_event()
			change_popup.get_child(0).text = change_popup.get_child(0).text + "\n New input: " + str(event.as_text_keycode())
			InputHelper.replace_keyboard_input_at_index(action_name, input_index, event, true)

		if Input.is_key_pressed(KEY_ESCAPE):
			change_popup.visible = false


func change_input(value, action):
	var change_text = change_popup.get_child(0)
	while change_popup.visible == true:
		if Input.is_key_pressed(KEY_ESCAPE):
			change_popup.visible = false
		elif action_name == null:
			InputMap.action_erase_event(action, value)
			InputMap.action_add_event(action, value)
			print()
		else:
			return Input

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


func _on_restore_defaults_pressed() -> void:
	InputHelper.reset_all_actions()
