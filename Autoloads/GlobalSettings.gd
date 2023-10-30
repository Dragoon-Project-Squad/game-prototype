extends Node

signal fps_displayed(value)
signal mouse_sens_updated(value)

func toggle_fullscreen(value):
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (value) else Window.MODE_WINDOWED


func toggle_sync(value):
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (value) else DisplayServer.VSYNC_DISABLED)


func toggle_fps_display(value):
	emit_signal("fps_displayed", value)


func set_max_fps(value):
	Engine.target_fps = value if value < 500 else 0

#TODO: Audio buses still need to be added
func update_master_vol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	
func update_music_vol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	
func update_sfx_vol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	
	
func update_mouse_sens(value):
	emit_signal("mouse_sens_updated", value)
