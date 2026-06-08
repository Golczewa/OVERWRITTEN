extends Control
var panel_pack =preload("res://scenes/menu/weapon_select.tscn")
var where_add_menu
@export var hand="left"
signal update_all_sig
func _ready() -> void:
	$button.pressed.connect(weapon_panel)
	update()
	
	
func weapon_panel():
	var panel=panel_pack.instantiate()
	panel.hand=hand
	panel.closed.connect(update_all)
	panel.position=Vector2(80,40)
	get_parent().add_child(panel)

func update():
	var num = ConfigManager.player_config.get_value("weapons", hand)
	$Label.text = ConfigManager.weapons.get_value(str(num), "name", "skill issue")
	$TextureRect.texture = load(ConfigManager.weapons.get_value(str(num), "image", "res://icon.svg"))
	
func update_all():
	emit_signal("update_all_sig")

	
