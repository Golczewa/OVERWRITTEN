extends Node3D


const map1_poz=[Vector3(-1.976,0.821,-0.285),Vector3(-9.0,-33.6,0)]
const map2_poz=[Vector3(2.815,1.141,2.231),Vector3(-14.4,-78.0,-1.0)]

var curr_map:Node3D

func _ready() -> void:
	$Camera3D.position=map1_poz[0]
	$Camera3D.rotation_degrees=map1_poz[1]
	curr_map=$map1
	await get_tree().create_timer(2).timeout
	switch_map(2) 


func switch_map(map_num:int,time:float=0.4)->void:
	var tween := create_tween().set_parallel()
	tween.tween_property($Camera3D,"position",get("map"+str(map_num)+"_poz")[0],time)
	tween.tween_property($Camera3D,"rotation_degrees",get("map"+str(map_num)+"_poz")[1],time)
	curr_map=get_node("map"+str(map_num))
