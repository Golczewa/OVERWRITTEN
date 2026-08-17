extends Control

@export var titles:Array[String]=["By Golczewa"]

func _ready() -> void:
	get_tree().current_scene.menu.connect(come)
	get_tree().current_scene.game.connect(begone)
	$Panel/VBoxContainer/Button.pressed.connect(open_map_choice)
	$map_choice/Button2.pressed.connect(get_main_menu)
	$map_choice/AspectRatioContainer.close_button.pressed.connect(get_main_menu)
	$Control/Button.pressed.connect(get_main_menu)
	$Panel/VBoxContainer/Button2.pressed.connect(show_quit_game_panel)
	var title_num=randi_range(0,len(titles)-1)
	$Panel/Label2.text=titles[title_num]


func open_map_choice():
	$map_choice.open()


func get_main_menu():
	$Panel.show()
	$map_choice.begone()
	$Control.hide()


func come():
	get_parent().show()
	get_main_menu()


func begone():
	get_parent().hide()


func setup_level_panel(num: int) -> void:
	$Control2.setup(num)


func hide_level_panel() -> void:
	destroy_weapon_choice()
	$Control2.go_back()


func destroy_weapon_choice():
	var wc = get_tree().get_first_node_in_group("weapon_select")
	if wc:
		wc.begone()


func show_quit_game_panel() -> void:
	$quit_game_panel.open()


func show_next_level(num: int):
	$map_choice.open()
	$Control2.setup(num)

#  ██████╗ ██╗   ██╗███████╗██████╗ ██╗    ██╗██████╗ ██╗████████╗████████╗███████╗███╗   ██╗
# ██╔═══██╗██║   ██║██╔════╝██╔══██╗██║    ██║██╔══██╗██║╚══██╔══╝╚══██╔══╝██╔════╝████╗  ██║
# ██║   ██║██║   ██║█████╗  ██████╔╝██║ █╗ ██║██████╔╝██║   ██║      ██║   █████╗  ██╔██╗ ██║
# ██║   ██║╚██╗ ██╔╝██╔══╝  ██╔══██╗██║███╗██║██╔══██╗██║   ██║      ██║   ██╔══╝  ██║╚██╗██║
# ╚██████╔╝ ╚████╔╝ ███████╗██║  ██║╚███╔███╔╝██║  ██║██║   ██║      ██║   ███████╗██║ ╚████║
#  ╚═════╝   ╚═══╝  ╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═══╝
