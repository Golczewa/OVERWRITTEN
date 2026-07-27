extends Node2D


@export_enum("left","right") var hand:String

func equip():
	ConfigManager.reload_player_config()
	for child in get_children():
		child.queue_free()
	var num = ConfigManager.player_config.get_value("weapons", hand)
	var weapon_pack = load(ConfigManager.weapons.get_value(str(num), "path", "res://scenes/player/fist.tscn"))
	var weapon = weapon_pack.instantiate()
	if hand == "left":
		weapon.scale = Vector2(1, -1)
	add_child(weapon)
	return weapon
