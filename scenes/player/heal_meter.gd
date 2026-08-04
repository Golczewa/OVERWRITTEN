extends Control

var charge_number: int
@onready var bars: Array = $Control.get_children()

var dragging = false
var drag_offset = Vector2()


func _ready() -> void:
	show()
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(begone)


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


func update_max(max_: int):
	for bar in bars:
		bar.max_value = max_


func update_value(val: int):
	if charge_number < 3:
		bars[charge_number].value = val


func update_charge(num: int):
	charge_number = num
	for i in range(num, len(bars)):
		print(i)
		bars[i].value = 0
