extends Node

var state: int = 0
signal menu
signal game

func _ready() -> void:
	$game.hide()
	$game.process_mode = Node.PROCESS_MODE_DISABLED
	$game/CanvasLayer/pause/VBoxContainer/Button3.pressed.connect(back_to_menu)
	$game/CanvasLayer/skill_issue/VBoxContainer/Button2.pressed.connect(back_to_menu)
	$game/CanvasLayer/skill_issue/AspectRatioContainer.close_button.pressed.connect(back_to_menu)


## Loads a level, shows the game scene, and hides the menu overlay.
func play_game(path: String) -> void:
	$CanvasLayer/loading.load_animation()
	emit_signal("game")
	$game.process_mode = Node.PROCESS_MODE_INHERIT
	$game.load_level(path)
	$CanvasLayer/loading.stop_loading()
	$CanvasLayer.hide()
	$CanvasLayer.process_mode = Node.PROCESS_MODE_DISABLED
	state = 1


## Returns to the main menu and disables the active game scene.
func back_to_menu() -> void:
	$game/CanvasLayer/pause.is_open = false
	get_tree().paused = false
	emit_signal("menu")
	$game.process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer.process_mode = Node.PROCESS_MODE_INHERIT
	state = 0


## Stops the level timer and opens the end-of-level score screen.
func end_level() -> void:
	$game.timer_stop()
	var score: Dictionary = $game.gameScore
	back_to_menu()
	$CanvasLayer/menu/Panel.hide()
	$CanvasLayer/menu/Control.setup(score)
