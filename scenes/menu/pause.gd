extends Control

var dragging = false
var is_open:bool=false
var drag_offset = Vector2()

func _ready() -> void:
	hide()
	$VBoxContainer/Button.pressed.connect(when_pressed)
	$VBoxContainer/Button2.pressed.connect(when_pressed)
	$AspectRatioContainer.close_button.pressed.connect(when_pressed)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(_on_panel_container_gui_input)

func  _input(event: InputEvent) -> void:
	if get_tree().current_scene.state==1:
		if event is InputEventKey:
			if event.keycode==KEY_ESCAPE and event.pressed and not is_open:
				open()
				is_open=true
				get_tree().paused=true

func  when_pressed():
	if get_tree().paused and is_open:
		hide()
		get_tree().paused=false
		is_open=false
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
	await $AspectRatioContainer.open_animation()
	for child in get_children():
		child.show() 