extends Node2D
@onready var player=$CharacterBody2D
var curr_scene



func load_level(path:String):
	if not curr_scene ==null:
		curr_scene.queue_free()
	var level_pre=load(path)
	var level=level_pre.instantiate()
	level.player=player
	curr_scene=level
	add_child(level)
