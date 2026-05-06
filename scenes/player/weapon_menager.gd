extends Node2D

var machete_pack=preload("res://scenes/enemies/machete.tscn")
var revolver_pack=preload("res://scenes/player/player_revolver.tscn")
var patchwork_pack=preload("res://scenes/player/player_patchwork.tscn")
var weapons=[machete_pack,revolver_pack,patchwork_pack]
@export_enum("left","right") var hand:String

func equip(num):
	var weapon= weapons[num].instantiate()
	weapon.is_owned_by_player=true
	weapon.skin="0"
	if hand=="left":
		weapon.scale=Vector2(1,-1)
	add_child(weapon)
	return weapon
