extends Node2D
@onready var player=$CharacterBody2D

func _ready() -> void:
	load_level("res://scenes/test_level.tscn")

func load_level(path:String):
	var level_pre=load(path)
	var level=level_pre.instantiate()
	add_child(level)
