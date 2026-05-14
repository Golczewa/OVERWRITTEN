extends Control
var weapons:ConfigFile
var card_pack=preload("res://scenes/menu/weapon_button.tscn")
var row_pack=preload("res://scenes/menu/weapon_row.tscn")
var to_untoggle:Button
var player_config:ConfigFile
var hand
signal closed

func _ready() -> void:
	$Panel/Button.pressed.connect(begone)
	load_config()
	var weapon_num=player_config.get_value("weapons",hand)
	var wep=weapons.get_sections()
	var row=row_pack.instantiate()
	for i in range(len(wep)):
		if i%4==0:
			row=row_pack.instantiate()
		if i%4==3:
			$Panel/VBoxContainer.add_child(row)
		var card=card_pack.instantiate()
		card.setup(weapons.get_value(str(i),"name","unknown"), weapons.get_value(str(i),"image","res://icon.svg"))
		card.mouse_entered.connect(display_disc.bind(i))
		card.pressed.connect(untoggling.bind(card))
		card.pressed.connect(equip.bind(i))
		if(i==weapon_num):
			card.button_pressed=true
			to_untoggle=card
		row.add_child(card)
	
func load_config():
	weapons=get_tree().get_first_node_in_group("game").weapons
	player_config=get_tree().get_first_node_in_group("game").player_config
	

func display_disc(i):
	$Panel/TextureRect.texture=load(weapons.get_value(str(i),"image","res://icon.svg"))
	$Panel/Label.text=weapons.get_value(str(i),"description")

func begone():
	emit_signal("closed")
	queue_free()

func untoggling(button:Button):
	if to_untoggle!=null:
		to_untoggle.button_pressed=false
	if to_untoggle==button:
		button.button_pressed=true
	to_untoggle=button

func equip(num:int):
	print(num)
	player_config.set_value("weapons",hand,num)
	player_config.save("res://config/player.cfg")
