extends MarginContainer

const FULLSCREEN = "window mode"
const MASTERVOL = "master volume"
const EFFECTSVOL = "effects volume"
const MUSICVOL = "music volume"
var is_loading := false
# Called when the node enters the scene tree for the first time.
func _ready():
	
	if not _INIT.is_loaded: await _INIT.loaded
	is_loading = true
	
	if FULLSCREEN in _INIT.data:
		%fullscreen.set_pressed_no_signal(_INIT.data[FULLSCREEN] == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		%fullscreen.set_pressed_no_signal(false)
	
	if MASTERVOL in _INIT.data:
		%master_vol.value = _INIT.data[MASTERVOL] * 100
	else:
		%master_vol.value = 50
	_on_master_vol_value_changed(%master_vol.value)
	
	if EFFECTSVOL in _INIT.data:
		%effects_vol.value = _INIT.data[EFFECTSVOL] * 100
	else:
		%effects_vol.value = 50
	_on_effects_vol_value_changed(%effects_vol.value)
	
	if MUSICVOL in _INIT.data:
		%music_vol.value = _INIT.data[MUSICVOL] * 100
	else:
		%music_vol.value = 50
	_on_music_vol_value_changed(%music_vol.value)
	
	is_loading = false
	
	var bb = load("res://blackboard.tres")
	if not bb: return
	if not "title_font" in bb: return
	%Sound.add_theme_font_override("font", bb.title_font)
	%Display.add_theme_font_override("font", bb.title_font)



var cached_window_mode = DisplayServer.WINDOW_MODE_WINDOWED
func _on_fullscreen_toggled(toggled_on):
	if toggled_on:
		if FULLSCREEN in _INIT.data:
			if _INIT.data[FULLSCREEN] != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
				cached_window_mode = DisplayServer.window_get_mode()
		_INIT.data[FULLSCREEN] = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
	else:
		_INIT.data[FULLSCREEN] = cached_window_mode
	DisplayServer.window_set_mode(_INIT.data[FULLSCREEN])
	if not is_loading: _INIT.Save()


func _on_master_vol_value_changed(value):
	var v := float(value) / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(v))
	_INIT.data[MASTERVOL] = v
	if not is_loading: _INIT.Save()


func _on_effects_vol_value_changed(value):
	var v := float(value) / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("effects"), linear_to_db(v))
	_INIT.data[EFFECTSVOL] = v
	if not is_loading: _INIT.Save()


func _on_music_vol_value_changed(value):
	var v := float(value) / 100.0
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear_to_db(v))
	_INIT.data[MUSICVOL] = v
	if not is_loading: _INIT.Save()

