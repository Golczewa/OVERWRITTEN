extends Control

var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func _ready() -> void:
	show()
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(begone)


func _on_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position
			
	if event is InputEventMouseMotion and dragging:
		var target_position: Vector2 = get_global_mouse_position() - drag_offset
		var viewport_size: Vector2 = get_viewport_rect().size
		var window_size: Vector2 = size
		target_position.x = clamp(target_position.x, 0, viewport_size.x - window_size.x)
		target_position.y = clamp(target_position.y, 0, viewport_size.y - window_size.y)
		global_position = target_position

## Hides the health bar panel.
func begone() -> void:
	hide()
