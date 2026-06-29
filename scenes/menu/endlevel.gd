extends Control

var dragging = false
var drag_offset = Vector2()

func _ready() -> void:
	hide()
	$Button.pressed.connect(hidee)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(hidee)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(_on_panel_container_gui_input)
	
func setup(score:Dictionary):
	count_score(score)
	$VBoxContainer/time.text="Time: "+format_time(score["time"])
	$VBoxContainer/deaths.text="Deaths: "+str(score["deaths"])
	$VBoxContainer/used.text="Healing used: "+str(score["hused"])
	$VBoxContainer/used2.text="Score: "+str(score["rank"])
	$rank.text="Rank: "+score["rank"]
	get_parent().come()
	show()

func count_score(_score:Dictionary):
	pass

func hidee():
	hide()

func format_time(time:int):
	var seconds=time%60
	var minutes=(time/60)
	var zero=""
	if seconds<10:
		zero="0"
	return str(minutes)+":"+zero+str(seconds)

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
	await $AspectRatioContainer.open_animation()
	for child in get_children():
		child.show() 
