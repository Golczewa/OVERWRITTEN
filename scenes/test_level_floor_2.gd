extends Node2D
var enemies=0
var spawn
var exit

func _ready() -> void:
	spawn=$Area2D/Marker2D.global_position
