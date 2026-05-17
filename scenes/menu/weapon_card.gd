extends Control
var panel_pack =preload("res://scenes/menu/weapon_select.tscn")
var weapons:ConfigFile
var player_config:ConfigFile
@export var hand="left"
signal update_all_sig
func _ready() -> void:
	load_config()
	$button.pressed.connect(weapon_panel)
	update()
	
	
func weapon_panel():
	var panel=panel_pack.instantiate()
	panel.hand=hand
	panel.closed.connect(update_all)
	get_parent().add_child(panel)

func update():
	var num =player_config.get_value("weapons",hand)
	$Label.text=weapons.get_value(str(num),"name","skill issue")
	$TextureRect.texture=load(weapons.get_value(str(num),"image","res://icon.svg"))
	
func load_config():
	weapons=get_tree().get_first_node_in_group("game").weapons
	player_config=get_tree().get_first_node_in_group("game").player_config

func update_all():
	emit_signal("update_all_sig")

	
