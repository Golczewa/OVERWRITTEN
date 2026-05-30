extends Control
var card_pack=preload("res://scenes/menu/weapon_button.tscn")
var row_pack=preload("res://scenes/menu/weapon_row.tscn")
var to_untoggle:Button
var hand: String
var weapon_num:int
signal closed

func _ready() -> void:
	$Panel/Button.pressed.connect(begone)
	weapon_num = ConfigManager.player_config.get_value("weapons", hand)
	var wep = ConfigManager.weapons.get_sections()
	var row=row_pack.instantiate()
	for i in range(len(wep)):
		if i%4==0:
			row=row_pack.instantiate()
		if i%4==3:
			$Panel/VBoxContainer.add_child(row)
		var card=card_pack.instantiate()
		card.setup(ConfigManager.weapons.get_value(str(i), "name", "unknown"), ConfigManager.weapons.get_value(str(i), "image", "res://icon.svg"))
		card.mouse_entered.connect(display_disc.bind(i))
		card.pressed.connect(untoggling.bind(card))
		card.pressed.connect(set_weapon_num.bind(i))
		if(i==weapon_num):
			card.button_pressed=true
			to_untoggle=card
		row.add_child(card)
	

func display_disc(i):
	$Panel/TextureRect.texture=load(ConfigManager.weapons.get_value(str(i), "image", "res://icon.svg"))
	$Panel/Label.text=ConfigManager.weapons.get_value(str(i), "description")

func begone():
	equip()
	emit_signal("closed")
	queue_free()

func untoggling(button:Button):
	if to_untoggle!=null:
		to_untoggle.button_pressed=false
	if to_untoggle==button:
		button.button_pressed=true
	to_untoggle=button

func equip():
	var current_weapon = ConfigManager.player_config.get_value("weapons", hand)
	if weapon_num == current_weapon:
		return
	var other_hand = null
	for side in ["left", "right"]:
		if side != hand and ConfigManager.player_config.get_value("weapons", side) == weapon_num:
			other_hand = side
			break
	if other_hand != null:
		ConfigManager.player_config.set_value("weapons", other_hand, current_weapon)
	ConfigManager.player_config.set_value("weapons", hand, weapon_num)
	ConfigManager.save_player_config()

func set_weapon_num(num:int):
	weapon_num=num
