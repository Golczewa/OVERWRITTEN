extends Area3D

func _ready():
	input_ray_pickable = true
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_hover_exit)
	input_event.connect(_on_klik)

func _on_klik(_camera, event, _pos, _normal, _idx):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		print("clicked")

func _on_hover():
	print("hover in")

func _on_hover_exit():
	print("hover_out")