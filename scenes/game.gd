extends Node2D
@onready var player = $CharacterBody2D
var curr_scene
var gameScore = {
	"level": 0, "time": 0, "deaths": 0, "hused": 0, "score": 0, "rank": "-", "cheats": false
}
signal kill_swich


func _ready() -> void:
	get_parent().menu.connect(hideGameUI)
	get_parent().game.connect(showGameUI)
	$CanvasLayer/skill_issue.restart.connect(restart)
	$CanvasLayer/pause/VBoxContainer/Button2.pressed.connect(restart)
	$Timer.timeout.connect(add_time)


func load_level(path: String):
	remove_bullets()
	unload_level()
	var level_pre = load(path)
	var level = level_pre.instantiate()
	level.player = player
	curr_scene = level
	player.clear_cheats()
	$CanvasLayer/Control.untoggle_all()
	add_child(level)
	remove_bullets()
	$CharacterBody2D.equip_weapons()
	resetScore()
	$Timer.start(1)
	gameScore["level"] = level.level_id


func restart():
	curr_scene.restart_floor()
	remove_bullets()
	$CanvasLayer/skill_issue.hide()
	$CanvasLayer/pause.hide()


func showGameUI():
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	remove_bullets()
	$CanvasLayer.show()
	$CanvasLayer/pause.hide()
	$CanvasLayer/skill_issue.hide()
	$CharacterBody2D/Camera2D/CanvasLayer.show()


func hideGameUI():
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer.hide()
	$CharacterBody2D/Camera2D/CanvasLayer.hide()


func resetScore():
	gameScore["level"] = 0
	gameScore["time"] = 0
	gameScore["deaths"] = 0
	gameScore["hused"] = 0
	gameScore["score"] = 0
	gameScore["rank"] = "-"
	gameScore["cheats"] = false


func add_time():
	gameScore["time"] = gameScore["time"] + 1
	$Timer.start(1)


func timer_stop():
	$Timer.stop()


func remove_bullets() -> void:
	var bullets := get_tree().get_nodes_in_group("bullets")
	for bullet in bullets:
		bullet.queue_free()


func open_cheats():
	$CanvasLayer/Control.toggle()


func kill_all():
	emit_signal("kill_swich")


func load_next_level(level_id: int):
	level_id += 1
	var level_path: String = ConfigManager.levels.get_value("level_" + str(level_id), "path")
	get_parent().play_game(level_path)


func unload_level():
	if curr_scene:
		curr_scene.queue_free()
