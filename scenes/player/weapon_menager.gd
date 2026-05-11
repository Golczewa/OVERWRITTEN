extends Node2D


@export_enum("left","right") var hand:String

func equip(path):
	var weapon_pack=load(path)
	var weapon= weapon_pack.instantiate()
	if hand=="left":
		weapon.scale=Vector2(1,-1)
	add_child(weapon)
	return weapon
