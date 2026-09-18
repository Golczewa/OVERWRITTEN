extends Node2D

class_name Level

@onready var player: Node
var curr_floor: int = 1
var floors: Array
@export var floors_loaded: Array[PackedScene]
var player_state: Dictionary
var checkpoint = 1
var real_curr_floor
@export var level_id = 1
signal restart


func _ready() -> void:
	get_parent().kill_swich.connect(kill_swich)
	for loaded_floor in floors_loaded:
		var floor_ = loaded_floor.instantiate()
		floors.append(floor_)
	add_child(floors[0])
	real_curr_floor = floors[0]
	await get_tree().process_frame
	player.load_state(player.default_state)
	player_state = player.default_state
	player.set_player_position(floors[0].spawn)
	var song = "level_" + str(level_id) + "_theme"
	AudioPlayer.play_with_entrance(AudioPlayer.get(song))


func move_up():
	player.clear_stray_warnings()
	if curr_floor >= len(floors):
		return
	if floors[curr_floor - 1].cleared:
		player_state = player.get_state()
		checkpoint = curr_floor + 1
	remove_child(floors[curr_floor - 1])
	curr_floor = curr_floor + 1
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].spawn)


func move_down():
	player.clear_stray_warnings()
	if curr_floor <= 1:
		return
	remove_child(floors[curr_floor - 1])
	curr_floor = curr_floor - 1
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].exit)


func restart_floor():
	print("res")
	if curr_floor < 1 or curr_floor > len(floors):
		curr_floor = checkpoint
	(floors[curr_floor - 1]).queue_free()
	curr_floor = checkpoint
	floors[curr_floor - 1] = floors_loaded[curr_floor - 1].instantiate()
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].spawn)
	player.load_state(player_state)
	restart.emit()


func end_level():
	get_tree().current_scene.end_level()
	queue_free()


func kill_swich():
	floors[curr_floor - 1].kill_all()


func jump_floor(floor_num: int):
	remove_child(floors[curr_floor - 1])
	curr_floor = floor_num
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].exit)
