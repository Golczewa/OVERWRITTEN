extends Node2D

var machete_pack=preload("res://scenes/machete.tscn")
var revolver_pack=preload("res://scenes/player_revolver.tscn")
var weapons=[machete_pack,revolver_pack]
@export_enum("left","right") var hand:String

func equip(num):
	var weapon= weapons[num].instantiate()
	weapon.is_owned_by_player=true
	weapon.skin="0"
	if hand=="left":
		weapon.scale(0,-1)
	add_child(weapon)
	return weapon
