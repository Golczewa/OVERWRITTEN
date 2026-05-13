extends Control
var panel_pack =preload("res://scenes/menu/weapon_select.tscn")

func _ready() -> void:
	$button.pressed.connect(weapon_panel)

func weapon_panel():
	var panel=panel_pack.instantiate()
	get_parent().add_child(panel)
