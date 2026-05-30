extends Node2D

@onready var floor1=preload("res://scenes/levels/level1/level1_floor1.tscn")

var player
var curr_floor:int=1
var floors:Array
var floors_loaded:Array
var player_state:Dictionary
var checkpoint=1
var real_curr_floor

func _ready() -> void:
	floors_loaded.append(floor1)
	for loaded_floor in floors_loaded:
		var floor_ = loaded_floor.instantiate()
		floors.append(floor_)
	add_child(floors[0])
	real_curr_floor=floors[0]
	player.set_player_position(floors[0].spawn)
	player.load_state(player.default_state)
	player_state=player.default_state

func move_up():
	if floors[curr_floor-1].cleard:
		player_state=player.get_state()
		checkpoint=curr_floor+1
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor+1
	add_child(floors[curr_floor-1])
	real_curr_floor=floors[curr_floor-1]
	player.set_player_position(floors[curr_floor-1].spawn)

func move_down():
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor-1
	add_child(floors[curr_floor-1])
	real_curr_floor=floors[curr_floor-1]
	player.set_player_position(floors[curr_floor-1].exit)

func restart_floor():
	remove_child(floors[curr_floor-1])
	curr_floor=checkpoint
	floors[curr_floor-1]=floors_loaded[curr_floor-1].instantiate()
	curr_floor=checkpoint
	add_child(floors[curr_floor-1])
	real_curr_floor=floors[curr_floor-1]
	player.set_player_position(floors[curr_floor-1].spawn)
	player.load_state(player_state)
	
func end_level():
	get_tree().current_scene.end_level()
	queue_free()
