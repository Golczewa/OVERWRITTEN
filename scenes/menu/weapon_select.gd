extends Control
var weapons:ConfigFile
var butt_pack=preload("res://scenes/menu/weapon_button.tscn")
var row_pack=preload("res://scenes/menu/weapon_row.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_config()
	var wep=weapons.get_sections()
	for i in range(4):
		var row=row_pack.instantiate()
		for j in range(4):
			var butt=butt_pack.instantiate()
			butt.text=weapons.get_value(str(j),"name","skill issue")
			row.add_child(butt)
		$Panel/VBoxContainer.add_child(row)
	
func load_config():
	var config=ConfigFile.new()
	var err = config.load("res://config/weapons.cfg")
	if err!=OK:
		print("confing loading error")
		return
	weapons=config
