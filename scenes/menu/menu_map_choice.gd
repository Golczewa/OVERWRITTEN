extends Control

var label_pack:PackedScene=preload("res://scenes/menu/level_label.tscn")
var dragging = false
var drag_offset = Vector2()

func _ready() -> void:
	hide()
	$Button.pressed.connect(level_setup.bind(0))
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(_on_panel_container_gui_input)
	setup_buttons()

func level_setup(num:int):
	get_parent().setup_level_panel(num)

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

func begone():
	hide()
	get_parent().hide_level_panel()

func show_label(pos:Vector3,num:int)->void:
	var button_pos=$SubViewportContainer/SubViewport/Node3D/Camera3D.unproject_position(pos)
	var container = $SubViewportContainer
	var viewport = $SubViewportContainer/SubViewport
	var ratio = container.size / Vector2(viewport.size)
	$PanelContainer.global_position = (container.global_position + button_pos * ratio) #+ Vector2(-55,-80)
	$PanelContainer.setup_label(num)

func hide_label()->void:
	$PanelContainer.hide_label()

func setup_buttons()->void:
	var buttons=$SubViewportContainer/SubViewport/Node3D/Node.get_children()
	for button in buttons:
		button.mouse_entered.connect(show_label.bind(button.global_position,button.level))
		button.mouse_exited.connect(hide_label)
		button.pressed_.connect(level_setup.bind(button.level))
		button.set_button_colors()
