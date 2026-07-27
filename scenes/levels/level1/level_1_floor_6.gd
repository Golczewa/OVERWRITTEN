extends Node2D
var enemies: int = 0
var spawn: Vector2
var exit: Vector2
var cleard: bool = false
@onready var sca_brute: PackedScene = preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner: PackedScene = preload("res://scenes/enemies/gooner_test.tscn")

func _ready() -> void:
	var waves1: Array = [[[1, sca_gooner]]]
	spawn = $Area2D4/Marker2D.global_position
	exit = $Area2D3/Marker2D.global_position
	$StaticBody2D2.setup(waves1)

func _physics_process(_delta: float) -> void:
	if enemies == 0:
		$StaticBody2D2.spawn_wave()
		if $StaticBody2D2.wave_remain <= 0:
			cleard = true

## Instantly kills every enemy on this floor.
func kill_all() -> void:
	var enemies_: Array[Node] = $enemies.get_children()
	for enemy: Node in enemies_:
		enemy.take_damage(99999, 0)
