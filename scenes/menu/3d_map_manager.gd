extends Node3D

var tween:Tween

const map1_poz = [Vector3(-1.976, 0.821, -0.285), Vector3(-9.0, -33.6, 0)]
const map2_poz = [Vector3(2.773, 1.521, 2.308), Vector3(-36.4, -81, 0)]
const map3_poz=[Vector3(1.652,1.665,5.714),Vector3(-25.1,-142.9,3.7)]

var curr_map: Node3D


func _ready() -> void:
	$Camera3D.position = map1_poz[0]
	$Camera3D.rotation_degrees = map1_poz[1]
	curr_map = $map1


func switch_map(map_num: int, time: float = 0.4) -> void:
	if tween:
		tween.kill()
	tween = create_tween().set_parallel()
	tween.tween_property($Camera3D, "position", get("map" + str(map_num) + "_poz")[0], time)
	tween.tween_property($Camera3D, "rotation_degrees", get("map" + str(map_num) + "_poz")[1], time)
	curr_map = get_node("map" + str(map_num))


func get_buttons() -> Array[Node]:
	return curr_map.get_node("Node3D").get_children()
