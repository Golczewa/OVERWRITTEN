extends Area3D

func _ready() -> void:
    input_event.connect(_on_input_event)
    monitoring = true
    input_ray_pickable = true

func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        button_clicked()

func button_clicked() -> void:
    var mesh := $MeshInstance3D as MeshInstance3D
    if mesh == null:
        return

    var material := mesh.material_override as StandardMaterial3D
    if material == null:
        material = StandardMaterial3D.new()

    material = material.duplicate()
    material.albedo_color = Color(1, 0, 0)
    material.emission = Color(1, 0, 0)
    mesh.material_override = material

    print("Model przycisku został kliknięty w 3D!")