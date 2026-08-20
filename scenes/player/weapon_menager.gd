extends Node2D

@export_enum("left", "right", "left_upper", "right_upper") var hand: String


func equip():
	if not ConfigManager.player_config.get_value("hands", hand, false):
		return
	ConfigManager.reload_player_config()
	for child in get_children():
		child.queue_free()
	var num = ConfigManager.player_config.get_value("weapons", hand, 0)
	var weapon_pack = load(
		ConfigManager.weapons.get_value(str(num), "path", "res://scenes/player/fist.tscn")
	)
	var weapon: PlayerWeapon = weapon_pack.instantiate()
	if hand == "left_upper" or hand == "right_upper":
		weapon.upper = true
	if hand == "left" or hand == "left_upper":
		weapon.left_hand = true
		weapon.scale = Vector2(1, -1)
	add_child(weapon)
	return weapon
