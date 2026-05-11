extends Node2D

var fist_pack=preload("res://scenes/player/fist.tscn")
var machete_pack=preload("res://scenes/player/player_machete.tscn")
var revolver_pack=preload("res://scenes/player/player_revolver.tscn")
var patchwork_pack=preload("res://scenes/player/player_patchwork.tscn")
var weapons=[fist_pack,machete_pack,revolver_pack,patchwork_pack]
@export_enum("left","right") var hand:String

func equip(num):
	var weapon= weapons[num].instantiate()
	if hand=="left":
		weapon.scale=Vector2(1,-1)
	add_child(weapon)
	return weapon
