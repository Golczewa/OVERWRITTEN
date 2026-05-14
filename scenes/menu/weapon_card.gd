extends Control
var panel_pack =preload("res://scenes/menu/weapon_select.tscn")
var weapons:ConfigFile
var player_config:ConfigFile
@export var hand="left"

func _ready() -> void:
	load_config()
	$button.pressed.connect(weapon_panel)
	update(player_config.get_value("weapons",hand))

func weapon_panel():
	var panel=panel_pack.instantiate()
	get_parent().add_child(panel)

func update(num):
	print(num)
	$Label.text=weapons.get_value(str(num),"name","skill issue")
	$TextureRect.texture=load(weapons.get_value(str(num),"image","res://icon.svg"))
	
func load_config():
	weapons=get_tree().get_first_node_in_group("game").weapons
	player_config=get_tree().get_first_node_in_group("game").player_config


	
