extends Area2D

var level
var player
var name_pre=preload("res://scenes/menu/level_title.tscn")
var level_title_

func _ready() -> void:
	level=get_parent().get_parent()
	player=get_tree().get_first_node_in_group("player")
	body_entered.connect(_on_body_entred)
	level_title_=ConfigManager.levels.get_value("level_"+str(level.level_id),"name","Error")

func _on_body_entred(body):
	if body==player:
		namedrop();

func namedrop():
	var name_=name_pre.instantiate()
	name_.text=level_title_
	player.canvas.add_child(name_)
	queue_free()
	
