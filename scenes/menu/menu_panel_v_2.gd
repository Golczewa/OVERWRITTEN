extends PanelContainer

var dragging = false
var drag_offset = Vector2()
@export var title:String="Title";
@onready var close_button:Button=$VBoxContainer/PanelContainer/HBoxContainer/Button;

func _ready() -> void:
	$VBoxContainer/PanelContainer/HBoxContainer/Label.text=" "+title+".ovr"
#	$VBoxContainer/PanelContainer.gui_input.connect(_on_panel_container_gui_input)

# func _on_panel_container_gui_input(event):
# 	if event is InputEventMouseButton:
# 		if event.button_index == MOUSE_BUTTON_LEFT:
# 			dragging = event.pressed
# 			drag_offset = get_global_mouse_position() - global_position
			
# 	if event is InputEventMouseMotion and dragging:
# 		global_position = get_global_mouse_position() - drag_offset
