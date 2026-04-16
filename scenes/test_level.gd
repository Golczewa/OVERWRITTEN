extends Node2D

@onready var floor1=preload("res://scenes/test_level_floor1.tscn")
@onready var floor2=preload("res://scenes/test_level_floor_2.tscn")
@onready var player = get_tree().get_first_node_in_group("player")
var curr_floor:int=1
var floors:Array

func _ready() -> void:
	var floor1_inst= floor1.instantiate()
	var floor2_inst=floor2.instantiate()
	floors.append(floor1_inst)
	floors.append(floor2_inst)
	add_child(floor1_inst)
	player.set_player_position(floors[curr_floor-1].spawn)

func move_up():
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor+1
	add_child(floors[curr_floor-1])
	player.set_player_position(floors[curr_floor-1].spawn)

func move_down():
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor-1
	add_child(floors[curr_floor-1])
	player.set_player_position(floors[curr_floor-1].exit)
