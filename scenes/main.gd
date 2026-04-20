extends Node2D

var game_pre=preload("res://scenes/game.tscn")
var menu_pre=preload("res://scenes/menu.tscn")

func _ready() -> void:
	load_menu()

func load_menu():
	var menu=menu_pre.instantiate()
	var play_button=menu.get_child("play_button")
	play_button.connect(load_game(menu))
	add_child(menu)
	
func load_game(menu):
	var game=game_pre.instantiate()
	remove_child(menu)
	add_child(game)
