extends Node2D
var enemies=0
var spawn
var exit
@onready var sca_brute=preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner=preload("res://scenes/enemies/gooner_test.tscn")
var cleard=false

func _ready() -> void:
	spawn=$Area2D/Marker2D.global_position

func _physics_process(_delta: float) -> void:
	if enemies==0 :
		cleard=true
