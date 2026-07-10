extends Node2D

@onready var floor1=preload("res://scenes/levels/level1/level1_floor1.tscn")
@onready var floor2=preload("res://scenes/levels/level1/level1_floor2.tscn")
@onready var floor3=preload("res://scenes/levels/level1/level1_floor3.tscn")
@onready var floor4=preload("res://scenes/levels/level1/level1_floor4.tscn")
@onready var floor5=preload("res://scenes/levels/level1/level1_floor5.tscn")
@onready var floor6=preload("res://scenes/levels/level1/level1_floor6.tscn")


var player
var curr_floor:int=1
var floors:Array
var floors_loaded:Array
var player_state:Dictionary
var checkpoint=1
var real_curr_floor
var level_id=1

func _ready() -> void:
	floors_loaded.append(floor1)
	floors_loaded.append(floor2)
	floors_loaded.append(floor3)
	floors_loaded.append(floor4)
	floors_loaded.append(floor6)
	floors_loaded.append(floor5)
	for loaded_floor in floors_loaded:
		var floor_ = loaded_floor.instantiate()
		floors.append(floor_)
	add_child(floors[0])
	real_curr_floor=floors[0]
	player.set_player_position(floors[0].spawn)
	player.load_state(player.default_state)
	player_state=player.default_state

func move_up():
	if curr_floor >= len(floors):
		return
	if floors[curr_floor-1].cleard:
		player_state=player.get_state()
		checkpoint=curr_floor+1
	remove_child(floors[curr_floor-1])
	print(curr_floor,"->",curr_floor+1)
	curr_floor=curr_floor+1
	add_child(floors[curr_floor-1])
	real_curr_floor=floors[curr_floor-1]
	player.set_player_position(floors[curr_floor-1].spawn)


func move_down():
	if curr_floor <= 1:
		return
	remove_child(floors[curr_floor-1])
	curr_floor=curr_floor-1
	print(curr_floor,"->",curr_floor-1)
	add_child(floors[curr_floor-1])
	real_curr_floor=floors[curr_floor-1]
	player.set_player_position(floors[curr_floor-1].exit)

func restart_floor():
	if curr_floor < 1 or curr_floor > len(floors):
		curr_floor=checkpoint
	remove_child(floors[curr_floor-1])
	curr_floor=checkpoint
	floors[curr_floor-1]=floors_loaded[curr_floor-1].instantiate()
	add_child(floors[curr_floor-1])
	real_curr_floor=floors[curr_floor-1]
	player.set_player_position(floors[curr_floor-1].spawn)
	player.load_state(player_state)
	
func end_level():
	get_tree().current_scene.end_level()
	queue_free()
