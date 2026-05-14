extends Node2D


@export_enum("left","right") var hand:String
var weapons:ConfigFile
var player_config:ConfigFile

func _ready() -> void:
	var config=ConfigFile.new()
	var err = config.load("res://config/weapons.cfg")
	if err!=OK:
		print("confing loading error")
		return
	weapons=config

func equip():
	load_config()
	for child in get_children():
		child.queue_free()
	var num=player_config.get_value("weapons",hand)
	var weapon_pack=load(weapons.get_value(str(num),"path","res://scenes/player/fist.tscn"))
	var weapon= weapon_pack.instantiate()
	if hand=="left":
		weapon.scale=Vector2(1,-1)
	add_child(weapon)
	return weapon

func load_config():
	var newconfig=ConfigFile.new()
	var newerr = newconfig.load("res://config/player.cfg")
	if newerr!=OK:
		print("confing loading error")
		return
	player_config=newconfig
