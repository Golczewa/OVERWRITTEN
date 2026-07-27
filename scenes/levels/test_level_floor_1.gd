extends Node2D
var enemies: int = 0
var spawn: Vector2
var exit: Vector2
@onready var sca_brute: PackedScene = preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner: PackedScene = preload("res://scenes/enemies/gooner_test.tscn")
var cleard: bool = false
var test: Variant

func _ready() -> void:
	var waves1: Array = [[[1, sca_brute], [1, sca_gooner]], [[1, sca_brute], [0, sca_gooner]]]
	spawn = $Marker2D.global_position
	exit = $Area2D/Marker2D.global_position
	$StaticBody2D.waves = waves1
	$StaticBody2D.wave_remain = len(waves1) - 1

func _physics_process(_delta: float) -> void:
	if enemies == 0:
		$StaticBody2D.spawn_wave()
		if $StaticBody2D.wave_remain <= 0:
			cleard = true
