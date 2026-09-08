extends Control

var dragging = false
var drag_offset = Vector2()
var in_animation: bool = false
var score_tween: Tween
var level_num: int
var unlock_screen_pack: PackedScene = preload("res://scenes/menu/weapon_unlocked.tscn")


func _ready() -> void:
	hide()
	$Button.pressed.connect(hidee)
	$Button2.pressed.connect(go_next)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Button.pressed.connect(hidee)
	$AspectRatioContainer/VBoxContainer/PanelContainer.gui_input.connect(
		_on_panel_container_gui_input
	)
	$AspectRatioContainer/VBoxContainer/PanelContainer/HBoxContainer/Control.gui_input.connect(
		_on_panel_container_gui_input
	)


func setup(score: Dictionary):
	AudioPlayer.play_with_entrance(AudioPlayer.level_complete)
	count_score(score)
	level_num = score["level"]
	$HBoxContainer.display("-")
	$VBoxContainer/time.text = "Time: " + format_time(score["time"])
	$VBoxContainer/deaths.text = "Deaths: " + str(score["deaths"])
	$VBoxContainer/used.text = "Healing used: " + str(score["hused"])
	ConfigManager.levels_progress.set_value("level_" + str(score["level"] + 1), "unlocked", true)
	if score["score"] > ConfigManager.levels.get_value("level_" + str(score["level"]), "score", 0):
		ConfigManager.levels_progress.set_value(
			"level_" + str(score["level"]), "score", score["score"]
		)
		ConfigManager.levels_progress.set_value(
			"level_" + str(score["level"]), "rank", score["rank"]
		)
	ConfigManager.save_levels_progress()
	ConfigManager.reload_levels_progress()
	unlock_next_level()
	get_tree().get_first_node_in_group("game").unload_level()
	open()
	await score_animation(score["score"])
	$VBoxContainer/used2.text = "Score: " + str(score["score"])
	if score["cheats"]:
		$HBoxContainer.display("Cheats")
	else:
		$HBoxContainer.display(score["rank"])


func count_score(_score: Dictionary) -> void:
	if _score["cheats"]:
		return
	var time_grade: Array = ConfigManager.levels.get_value(
		"level_" + str(_score["level"]), "grading_time"
	)
	var max_score = 1700
	var time_score: int = 0
	max_score += time_grade[0] / time_grade[1]
	time_score = time_grade[0] / _score["time"]
	var death_score: int
	if _score["deaths"] == 0:
		death_score = 1200
	else:
		death_score = 1000 / _score["deaths"]
	var h_score: int
	if _score["hused"] == 0:
		h_score = 500
	else:
		h_score = 400 / _score["hused"]
	var result = time_score + death_score + h_score
	_score["score"] = result
	var grade: String
	if result >= 5 * max_score / 6 and _score["deaths"] == 0:
		grade = "S"
	elif result >= 4 * max_score / 6:
		grade = "A"
	elif result >= 3 * max_score / 6:
		grade = "B"
	elif result >= 2 * max_score / 6:
		grade = "C"
	else:
		grade = "D"
	_score["rank"] = grade


func hidee():
	for child in get_children():
		if child != $AspectRatioContainer:
			child.hide()
	await $AspectRatioContainer.close_animation()
	hide()
	unlock_weapon(level_num + 1)
	AudioPlayer.play_music(AudioPlayer.menu_theme)


func format_time(time: int):
	var seconds = time % 60
	var minutes = time / 60
	var zero = ""
	if seconds < 10:
		zero = "0"
	return str(minutes) + ":" + zero + str(seconds)


func _on_panel_container_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed
			drag_offset = get_global_mouse_position() - global_position

	if event is InputEventMouseMotion and dragging:
		var target_position = get_global_mouse_position() - drag_offset
		var viewport_size = get_viewport_rect().size
		var window_size = size
		target_position.x = clamp(target_position.x, 0, viewport_size.x - window_size.x)
		target_position.y = clamp(target_position.y, 0, viewport_size.y - window_size.y)
		global_position = target_position


func open():
	for child in get_children():
		child.hide()
	show()
	await $AspectRatioContainer.open_animation()
	for child in get_children():
		child.show()


func score_animation(s: int):
	var time = s / 300
	in_animation = true
	$VBoxContainer/used2.text = "Score: "
	score_tween = create_tween()
	score_tween.tween_method(update_score, 0, s, time)
	await score_tween.finished


func update_score(s: int):
	$VBoxContainer/used2.text = "Score: " + str(s)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("skip_cuscene") and in_animation:
		score_tween.custom_step(1000)
		in_animation = false


func go_next():
	hidee()
	get_parent().show_next_level(level_num + 1)


func unlock_weapon(num):
	if ConfigManager.player_config.get_value("unlocked_weapons", str(num), true):
		return
	ConfigManager.player_config.set_value("unlocked_weapons", str(num), true)
	ConfigManager.save_player_config()
	var unlocked_screen: MenuWindow = unlock_screen_pack.instantiate()
	get_parent().add_child(unlocked_screen)
	unlocked_screen.show()
	unlocked_screen.unlock_weapon(num)


func unlock_next_level():
	if ConfigManager.levels_progress.get_value("level_" + str(level_num + 1), "unlocked", true):
		return
	ConfigManager.levels_progress.set_value("level_" + str(level_num + 1), "unlocked", true)
	ConfigManager.save_levels_progress()
