extends Node2D

class_name Floor

var enemies = 0
var cleared = false
var enemies_cleared := false
var spawn: Vector2
var exit: Vector2
var waves: Array
var waves_number: int = 0
@export var cutscenes: int = 0
@export var down_node: Node
@export var up_node: Node
@export var enemy_spawners: Array[Node]

@onready var sca_brute = preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner = preload("res://scenes/enemies/scavenger_gunner.tscn")
@onready var sca_hunter = preload("res://scenes/enemies/scavenger_hunter.tscn")
@onready var sca_rocketer = preload("res://scenes/enemies/scavenger_rocketer.tscn")


func _set_waves() -> void:
	waves = [[[[]]]]


func _ready() -> void:
	_set_waves()
	if down_node is Marker2D:
		spawn = down_node.global_position
	else:
		spawn = down_node.marker.global_position
	if up_node is Marker2D:
		exit = up_node.global_position
	else:
		exit = up_node.marker.global_position
	for i in range(len(enemy_spawners)):
		enemy_spawners[i].waves = waves[i]
		enemy_spawners[i].wave_remain = len(waves[i]) - 1
		waves_number += len(waves[i])


func _physics_process(_delta: float) -> void:
	if enemies == 0:
		if waves_number != 0:
			for spawner in enemy_spawners:
				spawner.spawn_wave()
		else:
			enemies_cleared = true
			if cutscenes <= 0:
				cleared = true


func kill_all():
	var enemies_ = $enemies.get_children()
	for enemy in enemies_:
		enemy.take_damage(99999, 0)


func add_enemy(enemy: CharacterBody2D, pos: Vector2) -> void:
	$enemies.add_child(enemy)
	enemy.global_position = pos
	enemies += 1
	cleared = false
	enemies_cleared = false
