extends Node2D

@onready var floor1: PackedScene = preload("res://scenes/levels/test_level_floor1.tscn")
@onready var floor2: PackedScene = preload("res://scenes/levels/test_level_floor_2.tscn")
@onready var floor3: PackedScene = preload("res://scenes/levels/test_level_floor3.tscn")
var player: CharacterBody2D
var curr_floor: int = 1
var floors: Array[Node2D] = []
var floors_loaded: Array[PackedScene] = []
var player_state: Dictionary
var checkpoint: int = 1
var real_curr_floor: Node2D
var level_id: int = 0

func _ready() -> void:
	floors_loaded.append(floor1)
	floors_loaded.append(floor2)
	floors_loaded.append(floor3)
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
	remove_child(floors[curr_floor - 1])
	curr_floor = curr_floor - 1
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].exit)

## Reloads the floor at the last checkpoint and restores player state.
func restart_floor() -> void:
	remove_child(floors[curr_floor - 1])
	curr_floor = checkpoint
	floors[curr_floor - 1] = floors_loaded[curr_floor - 1].instantiate()
	curr_floor = checkpoint
	add_child(floors[curr_floor - 1])
	real_curr_floor = floors[curr_floor - 1]
	player.set_player_position(floors[curr_floor - 1].spawn)
	player.load_state(player_state)

## Completes the level and removes this level node from the scene.
func end_level() -> void:
	get_tree().current_scene.end_level()
	queue_free()
