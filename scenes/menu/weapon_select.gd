extends Control
var card_pack = preload("res://scenes/menu/weapon_button.tscn")
var row_pack = preload("res://scenes/menu/weapon_row.tscn")
var to_untoggle: Button
var hand: String
var weapon_num: int
signal closed
var dragging = false
var drag_offset = Vector2()


func _ready() -> void:
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)
	$Button.pressed.connect(begone)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(begone)
	weapon_num = ConfigManager.player_config.get_value("weapons", hand)
	var wep = ConfigManager.weapons.get_sections()
	var row = row_pack.instantiate()
	await $AspectRatioContainer.open_animation()
	for i in range(len(wep)):
		if i % 4 == 0:
			row = row_pack.instantiate()
		var card = card_pack.instantiate()
		card.setup(
			ConfigManager.weapons.get_value(str(i), "name", "unknown"),
			ConfigManager.weapons.get_value(str(i), "image", "res://icon.svg"),
			ConfigManager.player_config.get_value("unlocked_weapons", str(i))
		)
		card.mouse_entered.connect(display_disc.bind(i))
		card.pressed.connect(untoggling.bind(card))
		card.pressed.connect(set_weapon_num.bind(i))
		if i == weapon_num:
			card.button_pressed = true
			to_untoggle = card
		row.add_child(card)
		if i % 4 == 3 or i == len(wep) - 1:
			$VBoxContainer.add_child(row)


func display_disc(i):
	if ConfigManager.player_config.get_value("unlocked_weapons", str(i)):
		$TextureRect.texture = load(
			ConfigManager.weapons.get_value(str(i), "image", "res://icon.svg")
		)
		$Label2.text = ConfigManager.weapons.get_value(str(i), "name")
		$Label.text = ConfigManager.weapons.get_value(str(i), "description")
	else:
		$TextureRect.texture = load("res://assets/menu/locked.png")
		$Label2.text = "???"
		$Label.text = ""


func begone():
	equip()
	emit_signal("closed")
	for child in get_children():
		if child != $AspectRatioContainer:
			child.hide()
	await $AspectRatioContainer.close_animation()
	queue_free()


func untoggling(button: Button):
	AudioPlayer.play(AudioPlayer.weapon_equip)
	if to_untoggle != null:
		to_untoggle.button_pressed = false
	if to_untoggle == button:
		button.button_pressed = true
	to_untoggle = button


func equip():
	var current_weapon = ConfigManager.player_config.get_value("weapons", hand)
	if weapon_num == current_weapon:
		return
	var other_hand = null
	for side in ["left", "right", "left_upper", "right_upper"]:
		if side != hand and ConfigManager.player_config.get_value("weapons", side) == weapon_num:
			other_hand = side
			break
	if other_hand != null:
		ConfigManager.player_config.set_value("weapons", other_hand, current_weapon)
	ConfigManager.player_config.set_value("weapons", hand, weapon_num)
	ConfigManager.save_player_config()


func set_weapon_num(num: int):
	weapon_num = num


func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position

	if event is InputEventMouseMotion and dragging:
		var target_position = get_global_mouse_position() - drag_offset
		var viewport_size = get_viewport_rect().size
		var window_size = size
		target_position.x = clamp(target_position.x, 0, viewport_size.x - window_size.x)
		target_position.y = clamp(target_position.y, 0, viewport_size.y - window_size.y)
		global_position = target_position
