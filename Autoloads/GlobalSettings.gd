extends Node

signal fps_displayed(value)
signal mouse_sens_updated(value)

const SAVEFILE = "user://SAVEFILE.save"

var appdata_path = ""
var game_data = {}

func _ready() -> void:
	appdata_path = ProjectSettings.globalize_path("user://")
	load_data()

func load_data():
	if FileAccess.file_exists(SAVEFILE):
		var save_file = FileAccess.open(SAVEFILE, FileAccess.READ)
		game_data = save_file.get_var()
		save_file.close()
	else:
		game_data = {
			"fullscreen_mode": 0,
			"res_index": 7,
			"vsync_mode": true,
			"max_fps": 120.0,
			"fps_visible": false,
			"master_vol": 0.8,
			"master_mute": false,
			"sfx_vol": 1.0,
			"sfx_mute": false,
			"music_vol": 1.0,
			"music_mute": false,
			"mouse_sens": 0.1
		}
		save_data()


func save_data():
	var save_file = FileAccess.open(SAVEFILE, FileAccess.WRITE)
	save_file.store_var(game_data)
	save_file.close()


# Video settings
# Bug: fullscreen modes have a 1px outline?
func toggle_fullscreen(index):
	match  index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		1: # Window Mode
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2: # Borderless Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		3: # Borderless Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	game_data.fullscreen_mode = index
	save_data()

func update_resolution(index):
	game_data.res_index = index
	save_data()

func toggle_sync(value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (value) else DisplayServer.VSYNC_DISABLED)
	game_data.vsync_mode = value
	save_data()


func toggle_fps_display(value):
	emit_signal("fps_displayed", value)
	game_data.fps_visible = value
	save_data()


# TODO: Is this the proper way to code this?
# Jono: probably, docs say this is the right value
func set_max_fps(value):
	Engine.max_fps = value if value < 500 else 0
	game_data.max_fps = value
	save_data()


# Audio
# TODO: Still need sound effects, music to test with
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, linear_to_db(vol))
	game_data.master_vol = vol
	save_data()

func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, linear_to_db(vol))
	game_data.music_vol = vol
	save_data()

func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, linear_to_db(vol))
	game_data.sfx_vol = vol
	save_data()


# Gameplay
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
	game_data.mouse_sens = value
	save_data()
