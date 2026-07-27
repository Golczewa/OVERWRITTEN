extends Node2D
var enemies: int = 0
var spawn: Vector2
var exit: Vector2
@onready var sca_brute: PackedScene = preload("res://scenes/enemies/scavenger_brute.tscn")
@onready var sca_gooner: PackedScene = preload("res://scenes/enemies/gooner_test.tscn")
var cleard: bool = false

func _ready() -> void:
	spawn = $Area2D/Marker2D.global_position

func _physics_process(_delta: float) -> void:
	if enemies == 0:
		cleard = true
