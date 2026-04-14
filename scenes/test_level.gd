extends Node2D

var floor1=preload("res://scenes/test_level_floor1.tscn")
var floor2=preload("res://scenes/test_level_floor_2.tscn")
var curr_floor:int=1
var floors:Array

func _ready() -> void:
	var floor1_inst= floor1.instantiate()
	var floor2_inst=floor2.instantiate()
	floors.append(floor1_inst)
	floors.append(floor2_inst)
	add_child(floor1_inst)


func move_up():
	floors[curr_floor-1].queue_free()
	curr_floor=curr_floor+1
	add_child(floors[curr_floor-1])

func move_down():
	floors[curr_floor-1].queue_free()
	curr_floor=curr_floor-1
	add_child(floors[curr_floor])
