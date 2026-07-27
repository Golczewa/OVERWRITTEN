extends Node2D

@onready var floor1: PackedScene = preload("res://scenes/levels/level1/level1_floor1.tscn")
@onready var floor2: PackedScene = preload("res://scenes/levels/level1/level1_floor2.tscn")
@onready var floor3: PackedScene = preload("res://scenes/levels/level1/level1_floor3.tscn")
@onready var floor4: PackedScene = preload("res://scenes/levels/level1/level1_floor4.tscn")
@onready var floor5: PackedScene = preload("res://scenes/levels/level1/level1_floor5.tscn")
@onready var floor6: PackedScene = preload("res://scenes/levels/level1/level1_floor6.tscn")

var player: CharacterBody2D
var curr_floor: int = 1
var floors: Array[Node2D] = []
var floors_loaded: Array[PackedScene] = []
var player_state: Dictionary
var checkpoint: int = 1
var real_curr_floor: Node2D
var level_id: int = 1

func _ready() -> void:
	get_parent().kill_swich.connect(kill_swich)
	floors_loaded.append(floor1)
	floors_loaded.append(floor2)
	floors_loaded.append(floor3)
	floors_loaded.append(floor4)
	floors_loaded.append(floor6)
	floors_loaded.append(floor5)
	for loaded_floor: PackedScene in floors_loaded:
		var floor_: Node2D = loaded_floor.instantiate()
		floors.append(floor_)
	add_child(floors[0])
	real_curr_floor = floors[0]
	player.set_player_position(floors[0].spawn)
	player.load_state(player.default_state)
	player_state = player.default_state

## Advances the player to the next floor when the current one is cleared.
func move_up() -> void:
	if curr_floor >= len(floors):
		return
	if floors[curr_floor - 1].cleard:
		player_state = player.get_state()
		checkpoint = curr_floor + 1
	remove_child(floors[curr_floor - 1])
	curr_floor = curr_floor + 1
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].spawn)

## Moves the player down to the previous floor.
func move_down() -> void:
	if curr_floor <= 1:
		return
	remove_child(floors[curr_floor - 1])
	curr_floor = curr_floor - 1
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].exit)

## Reloads the floor at the last checkpoint and restores player state.
func restart_floor() -> void:
	if curr_floor < 1 or curr_floor > len(floors):
		curr_floor = checkpoint
	remove_child(floors[curr_floor - 1])
	curr_floor = checkpoint
	floors[curr_floor - 1] = floors_loaded[curr_floor - 1].instantiate()
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].spawn)
	player.load_state(player_state)

## Completes the level and removes this level node from the scene.
func end_level() -> void:
	get_tree().current_scene.end_level()
	queue_free()

## Kills all enemies on the current floor.
func kill_swich() -> void:
	floors[curr_floor - 1].kill_all()

## Jumps directly to the given floor number.
func jump_floor(floor_num: int) -> void:
	remove_child(floors[curr_floor - 1])
	curr_floor = floor_num
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].exit)
