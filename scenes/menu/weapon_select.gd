extends Control
var weapons:ConfigFile
var card_pack=preload("res://scenes/menu/weapon_button.tscn")
var row_pack=preload("res://scenes/menu/weapon_row.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()
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
		row.add_child(card)
	
func load_config():
	var config=ConfigFile.new()
	var err = config.load("res://config/weapons.cfg")
	if err!=OK:
		print("confing loading error")
		return
	weapons=config

func display_disc(i):
	$Panel/TextureRect.texture=load(weapons.get_value(str(i),"image","res://icon.svg"))
	$Panel/Label.text=weapons.get_value(str(i),"description")
