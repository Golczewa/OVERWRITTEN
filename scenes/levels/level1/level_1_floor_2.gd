extends Node2D
var enemies=0
var spawn
var exit
var cleard=false
var enemy_spawner

func _ready() -> void:
	spawn=$Area2D2/Marker2D.global_position
	exit=$Area2D/Marker2D.global_position

func _physics_process(_delta: float) -> void:
	if enemies==0:
			cleard=true

func kill_all():
	var enemies_= $enemies.get_children()
	for enemy in enemies_:
		enemy.take_damage(99999,0)