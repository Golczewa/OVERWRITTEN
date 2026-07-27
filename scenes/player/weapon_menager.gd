extends Node2D


@export_enum("left","right") var hand: String

## Loads and attaches the configured weapon for this hand.
func equip() -> Node:
	ConfigManager.reload_player_config()
	for child: Node in get_children():
		child.queue_free()
	var num: int = ConfigManager.player_config.get_value("weapons", hand)
	var weapon_pack: PackedScene = load(ConfigManager.weapons.get_value(str(num), "path", "res://scenes/player/fist.tscn"))
	var weapon: Node = weapon_pack.instantiate()
	if hand == "left":
		weapon.scale = Vector2(1, -1)
	add_child(weapon)
	return weapon
