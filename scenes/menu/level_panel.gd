extends MenuWindow

var path: String
@export var max_level: int = 5


func _ready() -> void:
	hide()
	$HBoxContainer/Button3.pressed.connect(play)
	$HBoxContainer/Button.pressed.connect(go_back)
	$Control.update_all_sig.connect(update_all)
	$Control2.update_all_sig.connect(update_all)
	$Control3.update_all_sig.connect(update_all)
	$Control4.update_all_sig.connect(update_all)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(go_back)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)


func setup(num: int):
	if num >= max_level:
		go_back()
		return
	var section_name = "level_" + str(num)
	if ConfigManager.levels_progress.get_value(section_name, "unlocked") == true:
		open()
		if ConfigManager.levels_progress.get_value(section_name, "namedroped", false):
			$TextureRect.set_texture(load(ConfigManager.levels.get_value(section_name, "image")))
			$AspectRatioContainer.format_title(ConfigManager.levels.get_value(section_name, "name"))
		else:
			$TextureRect.set_texture(load("res://assets/level_thumbnail/unknown.png"))
			$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Label.text = " ???.ovr"
		$HBoxContainer2.display(ConfigManager.levels_progress.get_value(section_name, "rank"))
		$score.text = (
			"Best score: " + str(ConfigManager.levels_progress.get_value(section_name, "score"))
		)
		path = ConfigManager.levels.get_value(section_name, "path")
		update_all()


func play():
	get_tree().current_scene.play_game(path)
	hide()


func go_back():
	get_parent().destroy_weapon_choice()
	begone()


func update_all():
	$Control.update()
	$Control2.update()
	$Control3.update()
	$Control4.update()
