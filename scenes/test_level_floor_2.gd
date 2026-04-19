extends Node2D
var enemies=0
var spawn
var exit
@onready var sca_brute=preload("res://scenes/scavenger_brute.tscn")
@onready var sca_gooner=preload("res://scenes/gooner_test.tscn")

func _ready() -> void:
	var waves1=[[[1,sca_brute],[1,sca_gooner]],[[1,sca_brute],[1,sca_gooner]]]
	var waves2=[[[2,sca_gooner]],[[2,sca_brute]]]
	spawn=$Marker2D.global_position
	exit=$Area2D/Marker2D.global_position
	$StaticBody2D2.waves=waves1
	$StaticBody2D2.wave_remain=len(waves1)-1
	$StaticBody2D3.waves=waves2
	$StaticBody2D3.wave_remain=len(waves2)-1

func _physics_process(_delta: float) -> void:
	if enemies==0 :
		$StaticBody2D3.spawn_wave()
		$StaticBody2D2.spawn_wave()
