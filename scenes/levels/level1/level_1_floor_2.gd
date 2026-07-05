extends Node2D
var enemies=0
var spawn
var exit
var cleard=true

func _ready() -> void:
	spawn=$Area2D2/Marker2D.global_position
	exit=$Area2D/Marker2D.global_position
