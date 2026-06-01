extends Control



func _ready() -> void:
	get_tree().current_scene.menu.connect(come)
	get_tree().current_scene.game.connect(begone)
	$Panel/VBoxContainer/Button.pressed.connect(open_map_choice)
	$map_choice/Panel/Button2.pressed.connect(get_main_menu)
	$map_choice/Panel.close_button.pressed.connect(get_main_menu)
	$Control/Button.pressed.connect(get_main_menu)

func open_map_choice():
	$Panel.hide()
	$map_choice.show()


func get_main_menu():
	$Panel.show()
	$map_choice.hide()
	$Control.hide()

func come():
	get_parent().show()
	get_main_menu()

func begone():
	get_parent().hide()
	
#  ██████╗ ██╗   ██╗███████╗██████╗ ██╗    ██╗██████╗ ██╗████████╗████████╗███████╗███╗   ██╗
# ██╔═══██╗██║   ██║██╔════╝██╔══██╗██║    ██║██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔════╝████╗  ██║
# ██║   ██║██║   ██║█████╗  ██████╔╝██║ █╗ ██║██████╔╝██║   ██║      ██║   █████╗  ██╔██╗ ██║
# ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██║███╗██║██╔══██╗██║   ██║      ██║   ██╔══╝  ██║╚██╗██║
# ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║╚███╔███╔╝██║  ██║██║   ██║      ██║   ███████╗██║ ╚████║
#  ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═══╝
																						   
