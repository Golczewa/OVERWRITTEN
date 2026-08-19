extends Control

class_name MenuWindow

@export var panel:PanelContainer

var dragging = false
var drag_offset = Vector2()
var in_animation: bool = false

func _ready() -> void:
	hide()
	panel.gui_input.connect(
		_on_panel_container_gui_input
	)
	panel.gui_input.connect(
		_on_panel_container_gui_input
	)
	panel.close_button.pressed.connect(begone)

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


func open():
	show()
	for child in get_children():
		child.hide()
	await panel.open_animation()
	for child in get_children():
		if not child == panel:
			child.show()

func begone():
	for child in get_children():
		if child != panel:
			child.hide()
	await panel.close_animation()
	hide()
