extends Node2D

var curr_scene
var in_game

func _ready() -> void:
	load_menu()

func load_menu():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	curr_scene=get_child(0)
	curr_scene.play.pressed.connect(load_game())
	in_game=false
	
func load_game():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	curr_scene=get_child(0)
	in_game=true
