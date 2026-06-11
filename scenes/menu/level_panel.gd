extends Control

var dragging = false
var drag_offset = Vector2()
var path:String
	
func _ready() -> void:
	hide()
	$HBoxContainer/Button3.pressed.connect(play)
	$HBoxContainer/Button.pressed.connect(go_back)
	$Control.update_all_sig.connect(update_all)
	$Control2.update_all_sig.connect(update_all)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(go_back)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(_on_panel_container_gui_input)



func setup(num:int):
	var section_name="level_"+str(num)
	if ConfigManager.levels.get_value(section_name, "unlocked") == true:
		show()
		$TextureRect.set_texture(load(ConfigManager.levels.get_value(section_name, "image")))
		$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Label.text =" "+ ConfigManager.levels.get_value(section_name, "name").replace(" ","_")+".ovr"
		$rank.text = "Rank: " + ConfigManager.levels.get_value(section_name, "rank")
		$score.text = "Best score: " + str(ConfigManager.levels.get_value(section_name, "score"))
		path = ConfigManager.levels.get_value(section_name, "path")
		update_all()

func play():
		get_tree().current_scene.play_game(path)
		hide()

func go_back():
	get_parent().destroy_weapon_choice()
	hide()
	

func update_all():
	$Control.update()
	$Control2.update()

func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position
			
	if event is InputEventMouseMotion and dragging:
		var target_position = get_global_mouse_position() - drag_offset
		var viewport_size = get_viewport_rect().size
		var window_size = size
		target_position.x = clamp(target_position.x, 0, viewport_size.x - window_size.x)
		target_position.y = clamp(target_position.y, 0, viewport_size.y - window_size.y)
		global_position = target_position
