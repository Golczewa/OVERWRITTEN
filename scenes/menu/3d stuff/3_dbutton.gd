extends Area3D

func _ready() -> void:
	input_event.connect(_on_input_event)


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		button_clicked()

func button_clicked():
	var material=$MeshInstance3D.material_override as StandardMaterial3D
	if material:
		material=material.duplicate()
		material.albedo_color=Color(1,0,0)
		material.emission=Color(1,0,0)
	print("Model przycisku został kliknięty w 3D!")
