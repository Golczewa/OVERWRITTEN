extends Control

var dragging = false
var drag_offset = Vector2()
var is_open:bool=false
@onready var player=get_tree().get_first_node_in_group("player")

func _ready() -> void:
	hide()
	$VBoxContainer/Button.pressed.connect(toogle_invincible)
	$VBoxContainer/Button2.pressed.connect(toogle_invisible)
	$VBoxContainer/Button3.pressed.connect(toogle_kill_swich)
	$VBoxContainer/Button4.pressed.connect(jump_up)
	$VBoxContainer/Button5.pressed.connect(jump_down)
	$Button.pressed.connect(begone)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(begone)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(_on_panel_container_gui_input)

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
	for child in get_children():
		child.hide()	
	show()
	await $AspectRatioContainer.open_animation()
	for child in get_children():
		child.show() 

func begone():
	is_open=false
	for child in get_children():
		if child !=$AspectRatioContainer:
			child.hide()
	await $AspectRatioContainer.close_animation()
	hide()

func toogle_invisible():
	player.make_invisible()

func toogle_invincible():
	player.make_invincible()
	
func untoggle_all():
	var buttons=$VBoxContainer.get_children()
	for button in buttons:
		button.button_pressed=false

func toogle_kill_swich():
	player.enable_killswich()

func toggle():
	if is_open:
		is_open=false
		begone()
	else:
		is_open=true
		open()

func jump_up():
	get_parent().get_parent().curr_scene.move_up()
	player.enable_floor_jumping()

func jump_down():
	get_parent().get_parent().curr_scene.move_down()
	player.enable_floor_jumping()
