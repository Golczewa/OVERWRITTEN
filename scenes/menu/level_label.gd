extends PanelContainer


func setup_label(i: int) -> void:
	var section: String = "level_" + str(i)
	if ConfigManager.levels_progress.get_value(section, "namedroped", false):
		print(section)
		var level_name =  ConfigManager.levels.get_value(section, name, "???")
		$Label.text = " " + level_name + " "
	else:
		print("shimmy shimmy yay")
		$Label.text = " ??? "
		size = Vector2(106, 48)
	var x_offset: int = (106 + (len($Label.text) - 5) * 9) / 2
	global_position = global_position + Vector2(-x_offset, -80)
	show()


func hide_label():
	hide()
	$Label.text = " ??? "
	size = Vector2(106, 48)
