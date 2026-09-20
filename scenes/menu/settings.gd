extends MenuWindow


func _ready() -> void:
	hide()
	panel.upper_panel.gui_input.connect(_on_panel_container_gui_input)
	panel.upper_bar.gui_input.connect(_on_panel_container_gui_input)
	panel.close_button.pressed.connect(begone)
	$Button2.pressed.connect(begone)
	$Button.pressed.connect(apply_settings)
	$HBoxContainer/VBoxContainer2/OptionButton.overwrite_options(get_resolutions())
	$HBoxContainer/VBoxContainer2/HSlider.value_changed.connect(set_volume)
	$HBoxContainer/VBoxContainer2/HSlider2.value_changed.connect(set_sfx_volume)
	$HBoxContainer/VBoxContainer2/HSlider.drag_ended.connect(save_music)
	$HBoxContainer/VBoxContainer2/HSlider2.drag_ended.connect(save_sfx)
	update_values()


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


func apply_settings():
	var window := get_window()
	var mode: String = $HBoxContainer/VBoxContainer2/OptionButton2.options[
		$HBoxContainer/VBoxContainer2/OptionButton2.selected
	]
	if mode == "Fullscreen":
		ConfigManager.player_config.set_value("settings", "mode", "Fullscreen")
		window.mode = Window.MODE_FULLSCREEN
		ConfigManager.save_player_config()
		return
	AudioPlayer.play(AudioPlayer.menu_window_open)
	var res: String = $HBoxContainer/VBoxContainer2/OptionButton.options[
		$HBoxContainer/VBoxContainer2/OptionButton.selected
	]
	ConfigManager.player_config.set_value("settings", "resolution", res)
	ConfigManager.player_config.set_value("settings", "mode", "Windowed")
	var hight_and_widh := res.split("x")
	var true_res := Vector2i(int(hight_and_widh[0]), int(hight_and_widh[1]))
	window.mode = Window.MODE_WINDOWED
	window.size = true_res
	window.move_to_center()
	ConfigManager.save_player_config()


func save_music(_value_changed: bool):
	ConfigManager.player_config.set_value(
		"settings", "music", $HBoxContainer/VBoxContainer2/HSlider.value / 100
	)
	ConfigManager.save_player_config()


func save_sfx(_value_changed: bool):
	ConfigManager.player_config.set_value(
		"settings", "sfx", $HBoxContainer/VBoxContainer2/HSlider2.value / 100
	)
	ConfigManager.save_player_config()


func update_values():
	$HBoxContainer/VBoxContainer2/HSlider.value = (
		ConfigManager.player_config.get_value("settings", "music", 1) * 100
	)
	$HBoxContainer/VBoxContainer2/HSlider2.value = (
		ConfigManager.player_config.get_value("settings", "sfx", 1) * 100
	)
	var index1 = $HBoxContainer/VBoxContainer2/OptionButton.options.find(
		ConfigManager.player_config.get_value("settings", "resolution")
	)
	var index2 = $HBoxContainer/VBoxContainer2/OptionButton2.options.find(
		ConfigManager.player_config.get_value("settings", "mode")
	)
	$HBoxContainer/VBoxContainer2/OptionButton._on_item_picked(index1)
	$HBoxContainer/VBoxContainer2/OptionButton2._on_item_picked(index2)


func open():
	update_values()
	show()
	for child in get_children():
		child.hide()
	await panel.open_animation()
	for child in get_children():
		if not child == panel:
			child.show()
