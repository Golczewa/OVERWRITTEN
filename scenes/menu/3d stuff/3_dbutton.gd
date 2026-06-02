extends Area3D

func _ready() -> void:
	input_event.connect(_on_input_event)


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		button_clicked()

func button_clicked():
	print("Model przycisku został kliknięty w 3D!")
