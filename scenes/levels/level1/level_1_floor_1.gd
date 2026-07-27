extends Node2D
var enemies=0
var spawn
var exit
var cleard=true

func _ready() -> void:
	spawn=$Marker2D2.global_position
	exit=$Area2D/Marker2D.global_position


func kill_all():
	var enemies_= $enemies.get_children()
	for enemy in enemies_:
		enemy.take_damage(99999,0)