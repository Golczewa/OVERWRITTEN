extends Area2D
var player
var menu_pack = preload("res://scenes/menu/post_menu.tscn")
var unlock_screen_pack: PackedScene = preload("res://scenes/menu/weapon_unlocked.tscn")
var tutorial_window_pack: PackedScene = preload("res://scenes/menu/warning_window.tscn")
var menu
var floor_: Floor
signal done


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	if not ConfigManager.player_config.get_value("unlocked_weapons", str(1), true):
		print("Dwadawdawdaw")
		var tutorial_window = tutorial_window_pack.instantiate()
		player.canvas.add_child(tutorial_window)
		tutorial_window.setup($Marker2D, Vector2(108, 49), done, "Special delivery!")
	floor_ = get_parent().get_parent()
	body_entered.connect(show_menu)
	body_exited.connect(hide_menu)


func show_menu(body):
	if body == player and floor_.enemies_cleared:
		menu = menu_pack.instantiate()
		player.canvas.add_child(menu)
		unlock_revolver()


func hide_menu(body):
	if body == player and floor_.enemies_cleared:
		if menu:
			menu.queue_free()


func _process(_delta: float) -> void:
	if floor_.enemies_cleared:
		$PointLight2D.enabled = true
	else:
		$PointLight2D.enabled = false


func unlock_revolver():
	if ConfigManager.player_config.get_value("unlocked_weapons", str(1), true):
		return
	ConfigManager.player_config.set_value("unlocked_weapons", str(1), true)
	ConfigManager.save_player_config()
	var unlocked_screen: MenuWindow = unlock_screen_pack.instantiate()
	player.canvas.add_child(unlocked_screen)
	unlocked_screen.unlock_weapon(1)
	floor_.cutscenes -= 1
	done.emit()
