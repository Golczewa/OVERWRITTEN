extends MenuWindow


func _ready() -> void:
	hide()
	panel.upper_panel.gui_input.connect(_on_panel_container_gui_input)
	panel.upper_bar.gui_input.connect(_on_panel_container_gui_input)
	panel.close_button.pressed.connect(begone)
	$Button2.pressed.connect(begone)
	$Button.pressed.connect(apply_res)
	$HBoxContainer/VBoxContainer2/OptionButton.overwrite_options(get_resolutions())
	$HBoxContainer/VBoxContainer2/HSlider.value_changed.connect(set_volume)
	$HBoxContainer/VBoxContainer2/HSlider2.value_changed.connect(set_sfx_volume)


#	get_tree().current_scene.game.connect(begone)


func set_volume(value: float):
	var precent: float = value / 100
	AudioPlayer.change_music_volume(precent)


func set_sfx_volume(value: float):
	var precent: float = value / 100
	AudioPlayer.change_sfx_volume(precent)


func get_resolutions() -> Array[String]:
	var max_resolution := DisplayServer.screen_get_size()
	var scales: Array[float] = [1, 0.8, 0.75, 0.5, 0.25]
	var resolutions: Array[String]
	for scaler in scales:
		var w := int(max_resolution.x * scaler)
		var h := int(max_resolution.y * scaler)
		var res: String = str(w) + "x" + str(h)
		resolutions.append(res)
	return resolutions


func apply_res():
	AudioPlayer.play(AudioPlayer.menu_window_open)
	var res: String = $HBoxContainer/VBoxContainer2/OptionButton.options[
		$HBoxContainer/VBoxContainer2/OptionButton.selected
	]
	var hight_and_widh := res.split("x")
	var true_res = Vector2i(int(hight_and_widh[0]), int(hight_and_widh[1]))
	var window := get_window()
	window.mode = Window.MODE_WINDOWED
	window.size = true_res
	window.move_to_center()


func apply_mode():
	var mode: String = $HBoxContainer/VBoxContainer2/OptionButton2.options[
		$HBoxContainer/VBoxContainer2/OptionButton2.selected
	]
	if mode == "Fullscreen":
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
