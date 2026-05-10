extends Control


func _ready() -> void:
	$Panel/Button.pressed.connect(open_map_choice)
	$map_choice/Button2.pressed.connect(get_main_menu)
	$Control/Button.pressed.connect(get_main_menu)

func open_map_choice():
	$Panel.hide()
	$map_choice.show()


func get_main_menu():
	$Panel.show()
	$map_choice.hide()
	$Control.hide()
