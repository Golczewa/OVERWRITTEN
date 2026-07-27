extends Node2D

@onready var player: CharacterBody2D = $CharacterBody2D
var curr_scene: Level
var gameScore: Dictionary = {
	"level": 0,
	"time": 0,
	"deaths": 0,
	"hused": 0,
	"score": 0,
	"rank": "-",
	"cheats": false,
}
signal kill_swich

func _ready() -> void:
	get_parent().menu.connect(hideGameUI)
	get_parent().game.connect(showGameUI)
	$CanvasLayer/skill_issue.restart.connect(restart)
	$CanvasLayer/pause/VBoxContainer/Button2.pressed.connect(restart)
	$Timer.timeout.connect(add_time)


## Instantiates a level from path, equips weapons, and resets score/timer.
func load_level(path: String) -> void:
	remove_bullets()
	if not curr_scene == null:
		curr_scene.queue_free()
	var level_pre: Resource = load(path)
	var level: Level = level_pre.instantiate()
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


## Restarts the current floor and closes pause/death overlays.
func restart() -> void:
	curr_scene.restart_floor()
	remove_bullets()
	$CanvasLayer/skill_issue.hide()
	$CanvasLayer/pause.hide()


## Shows game UI and re-enables processing when entering gameplay.
func showGameUI() -> void:
	show()
	process_mode = Node.PROCESS_MODE_INHERIT
	remove_bullets()
	$CanvasLayer.show()
	$CanvasLayer/pause.hide()
	$CanvasLayer/skill_issue.hide()
	$CharacterBody2D/Camera2D/CanvasLayer.show()


## Hides game UI and disables processing when returning to menu.
func hideGameUI() -> void:
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer.hide()
	$CharacterBody2D/Camera2D/CanvasLayer.hide()


## Resets all score tracking fields to their initial values.
func resetScore() -> void:
	gameScore["level"] = 0
	gameScore["time"] = 0
	gameScore["deaths"] = 0
	gameScore["hused"] = 0
	gameScore["score"] = 0
	gameScore["rank"] = "-"
	gameScore["cheats"] = false


func add_time() -> void:
	gameScore["time"] = gameScore["time"] + 1
	$Timer.start(1)


## Stops the elapsed-time counter for the current level.
func timer_stop() -> void:
	$Timer.stop()


func remove_bullets() -> void:
	var bullets: Array[Node] = get_tree().get_nodes_in_group("bullets")
	for bullet: Node in bullets:
		bullet.queue_free()


func open_cheats() -> void:
	$CanvasLayer/Control.toggle()


## Emits kill switch signal to wipe enemies on the current floor.
func kill_all() -> void:
	emit_signal("kill_swich")


## Loads the next level by id via the main scene play_game flow.
func load_next_level(level_id: int) -> void:
	level_id += 1
	var level_path: String = ConfigManager.get_level_value("level_" + str(level_id), "path")
	print(level_path)
	get_parent().play_game(level_path)
