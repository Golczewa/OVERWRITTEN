extends Control

@export var titles: Array[String] = ["By Golczewa"]
var weapon_choice: MenuWindow


func _ready() -> void:
	get_tree().current_scene.menu.connect(come)
	get_tree().current_scene.game.connect(begone)
	$Panel/VBoxContainer/Button.pressed.connect(open_map_choice)
	$map_choice/Button2.pressed.connect(get_main_menu)
	$map_choice/AspectRatioContainer.close_button.pressed.connect(get_main_menu)
	$Control/Button.pressed.connect(get_main_menu)
	$Panel/VBoxContainer/Button2.pressed.connect(show_quit_game_panel)
	var title_num = randi_range(0, len(titles) - 1)
	$Panel/Label2.text = titles[title_num]
	$Panel/VBoxContainer/Button3.pressed.connect($MenuWindow.open)
	$Panel/VBoxContainer/Button4.pressed.connect(open_credits)
	AudioPlayer.play_music(AudioPlayer.menu_theme)


func open_map_choice()->void:
	$map_choice.open([$map_choice.panel,$map_choice/PanelContainer])


func get_main_menu()->void:
	$map_choice.begone()
	$Control.hide()


func come()->void:
	get_parent().show()
	get_main_menu()


func begone()->void:
	get_parent().hide()


func setup_level_panel(num: int) -> void:
	$Control2.setup(num)


func hide_level_panel() -> void:
	destroy_weapon_choice()
	$Control2.go_back()


func destroy_weapon_choice() -> void:
	if weapon_choice:
		weapon_choice.delete()


func show_quit_game_panel() -> void:
	$quit_game_panel.open()


func show_next_level(num: int):
	$map_choice.open([$map_choice.panel,$map_choice/PanelContainer])
	$Control2.setup(num)


func open_credits()->void:
	$MenuWindow2.open()