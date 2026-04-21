extends Node2D

var curr_scene
var in_game

func _ready() -> void:
	load_game()

func load_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	in_game=false
	
func load_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	in_game=true
