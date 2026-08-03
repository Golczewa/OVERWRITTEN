extends Node2D
var enemies = 0
var spawn
var exit
@onready var sca_brute = preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner = preload("res://scenes/enemies/gooner_test.tscn")
var cleared = false
var test


func _ready() -> void:
	var waves1 = [[[1, sca_brute], [1, sca_gooner]], [[1, sca_brute], [0, sca_gooner]]]
	spawn = $Marker2D.global_position
	exit = $Area2D/Marker2D.global_position
	$StaticBody2D.waves = waves1
	$StaticBody2D.wave_remain = len(waves1) - 1


func _physics_process(_delta: float) -> void:
	if enemies == 0:
		$StaticBody2D.spawn_wave()
		if $StaticBody2D.wave_remain <= 0:
			cleared = true
