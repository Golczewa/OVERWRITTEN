extends Node2D
var enemies=0
var cleard=false
var spawn
var exit
var waves
@export var exit_node:Node
@export var spawn_node:Node
@export var enemy_spawners:Array[Node]

@onready var sca_brute=preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner=preload("res://scenes/enemies/gooner_test.tscn")

func set_waves()->void:
	waves=[[[[]]]]

func _ready() -> void:
	set_waves()
	spawn=spawn_node.marker.global_position
	exit=exit_node.marker.global_position
	for i in range(len(enemy_spawners)):
		enemy_spawners[i].waves=waves[i]
		enemy_spawners[i].wave_remain=len(waves[i])-1

func _physics_process(_delta: float) -> void:
	if enemies==0 :
		var all_done=true
		for spawner in enemy_spawners:
			spawner.spawn_wave()
			if spawner.wave_remain>0:
				all_done=false
		cleard=all_done

func kill_all():
	var enemies_= $enemies.get_children()
	for enemy in enemies_:
		enemy.take_damage(99999,0)