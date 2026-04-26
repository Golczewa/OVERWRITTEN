extends Node2D

@onready var floor1=preload("res://scenes/test_level_floor1.tscn")
@onready var floor2=preload("res://scenes/test_level_floor_2.tscn")
var player
var curr_floor:int=1
var floors:Array
var floors_loaded:Array
var player_state:Dictionary

func _ready() -> void:
	floors_loaded.append(floor1)
	floors_loaded.append(floor2)
	for loaded_floor in floors_loaded:
		var floor_ = loaded_floor.instantiate()
		floors.append(floor_)
	add_child(floors[0])
	player.set_player_position(floors[0].spawn)
	player.load_state(player.default_state)
	player_state=player.default_state

func move_up():
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor+1
	add_child(floors[curr_floor-1])
	player.set_player_position(floors[curr_floor-1].spawn)
	player_state=player.get_state()

func move_down():
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor-1
	add_child(floors[curr_floor-1])
	player.set_player_position(floors[curr_floor-1].exit)
	player_state=player.get_state()
	
func restart_floor():
	remove_child(floors[curr_floor-1])
	floors[curr_floor-1]=floors_loaded[curr_floor-1].instantiate()
	add_child(floors[curr_floor-1])
	player.set_player_position(floors[curr_floor-1].spawn)
	player.load_state(player_state)
