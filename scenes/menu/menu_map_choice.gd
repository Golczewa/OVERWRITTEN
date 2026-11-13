extends MenuWindow

var label_pack: PackedScene = preload("res://scenes/menu/level_label.tscn")
var curr_map := 1
var map_names := ["Old steelmill", "City outskirts", "Imaginary"]
var visited := [true, false, false]
const max_map := 3
@onready var map_manager: Node3D = $SubViewportContainer/SubViewport/Node3D


func _ready() -> void:
	hide()
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)
	$HBoxContainer/Button3.pressed.connect(next_map)
	$HBoxContainer/Button4.pressed.connect(previous_map)
	setup_buttons()
	_warmup_3d_preview()


func level_setup(num: int):
	print(num)
	get_parent().setup_level_panel(num)


func show_label(pos: Vector3, num: int) -> void:
	var camera_ = map_manager.get_node("Camera3D")
	var button_pos = camera_.unproject_position(pos)
	var container = $SubViewportContainer
	var viewport = $SubViewportContainer/SubViewport
	var ratio = container.size / Vector2(viewport.size)
	$PanelContainer.global_position = (container.global_position + button_pos * ratio)  #+ Vector2(-55,-80)
	$PanelContainer.setup_label(num)


func hide_label() -> void:
	$PanelContainer.hide_label()


func setup_buttons() -> void:
	var buttons = map_manager.get_buttons()
	for button in buttons:
		button.mouse_entered.connect(show_label.bind(button.global_position, button.level))
		button.mouse_exited.connect(hide_label)
		button.pressed_.connect(level_setup.bind(button.level))
		button.set_button_colors()


func refresh_buttons():
	var buttons = map_manager.get_buttons()
	for button in buttons:
		button.set_button_colors()


func _warmup_3d_preview() -> void:
	var viewport := $SubViewportContainer/SubViewport
	viewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().process_frame
	await get_tree().process_frame
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS


func next_map():
	AudioPlayer.play(AudioPlayer.menu_window_open)
	curr_map += 1
	if curr_map > max_map:
		curr_map = 1
	map_manager.switch_map(curr_map)
	swich_name(curr_map - 1)
	if !(visited[curr_map - 1]):
		setup_buttons()
		visited[curr_map - 1] = true
	else:
		refresh_buttons()


func previous_map():
	AudioPlayer.play(AudioPlayer.menu_window_open)
	curr_map -= 1
	if curr_map < 1:
		curr_map = max_map
	map_manager.switch_map(curr_map)
	swich_name(curr_map - 1)
	if !(visited[curr_map - 1]):
		setup_buttons()
		visited[curr_map - 1] = true
	else:
		refresh_buttons()


func swich_name(i: int):
	$Label.text = map_names[i]
