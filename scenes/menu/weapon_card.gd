extends Control
var panel_pack = preload("res://scenes/menu/weapon_select.tscn")
@export var in_game: bool = false
var where_add_menu
@export_enum("left", "right", "left_upper", "right_upper") var hand: String
signal update_all_sig


func _ready() -> void:
	$button.pressed.connect(weapon_panel)
	update()


func weapon_panel():
	if not is_panel_runing():
		var panel = panel_pack.instantiate()
		panel.hand = hand
		panel.closed.connect(update_all)
		if not in_game:
			panel.global_position = Vector2(200, 60)
			get_tree().get_first_node_in_group("menu").add_child(panel)
		else:
			panel.position = Vector2(100, 40)
			get_parent().add_child(panel)


func update():
	if ConfigManager.player_config.get_value("hands", hand, false):
		$button.disabled = false
		var num = ConfigManager.player_config.get_value("weapons", hand)
		$Label.text = ConfigManager.weapons.get_value(str(num), "name", "skill issue")
		$TextureRect.texture = load(
			ConfigManager.weapons.get_value(str(num), "image", "res://icon.svg")
		)
		$TextureRect.rotation_degrees = 16.4
		$TextureRect.position = Vector2(46, -21)
	else:
		$Label.text = "Locked"
		$TextureRect.texture = load("res://asstets/menu/locked.png")
		$TextureRect.rotation = 0
		$TextureRect.position = Vector2(28, 8)
		$button.disabled = true


func update_all():
	emit_signal("update_all_sig")


func is_panel_runing() -> bool:
	var result = get_tree().get_first_node_in_group("weapon_select")
	if result:
		return true
	return false
