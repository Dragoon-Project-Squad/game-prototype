extends Node

signal fps_displayed(value)
signal mouse_sens_updated(value)

func toggle_fullscreen(value):
	OS.window_fullscreen = value


func toggle_sync(value):
	OS.vsync_enabled = value


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
