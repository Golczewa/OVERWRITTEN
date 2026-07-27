extends Node2D
var enemies=0
var spawn
var exit
var cleard=false
@onready var sca_brute=preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner=preload("res://scenes/enemies/gooner_test.tscn")

func _ready() -> void:
	var waves1=[[[1,sca_gooner]]]
	var waves2=[[[1,sca_gooner]]]
	spawn=$Area2D2/Marker2D.global_position
	$StaticBody2D.setup(waves2)
	$StaticBody2D2.setup(waves1)


func _physics_process(_delta: float) -> void:
	if enemies==0 :
		$StaticBody2D.spawn_wave()
		$StaticBody2D2.spawn_wave()
		if $StaticBody2D.wave_remain<=0:
			cleard=true

func kill_all():
	var enemies_= $enemies.get_children()
	for enemy in enemies_:
		enemy.take_damage(99999,0)