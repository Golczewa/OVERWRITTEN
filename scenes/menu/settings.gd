extends MenuWindow


func _ready() -> void:
	hide()
	panel.upper_panel.gui_input.connect(_on_panel_container_gui_input)
	panel.upper_bar.gui_input.connect(_on_panel_container_gui_input)
	panel.close_button.pressed.connect(begone)
	$Button2.pressed.connect(begone)
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
	resolutions.append("1x1")
	return resolutions
