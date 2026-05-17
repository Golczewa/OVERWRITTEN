extends Node

var state=0
signal menu
signal game

func _ready() -> void:
	$game.hide()
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer/menu/Panel/Button2.pressed.connect(exit)
	$game/CanvasLayer/pause/Button2.pressed.connect(back_to_menu)
	
func play_game(path:String):
	emit_signal("game")
	$game.process_mode=Node.PROCESS_MODE_INHERIT
	$game.load_level(path)
	$CanvasLayer.hide()
	$CanvasLayer.process_mode=Node.PROCESS_MODE_DISABLED
	state=1

func back_to_menu():
	get_tree().paused = false
	emit_signal("menu")
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer.process_mode=Node.PROCESS_MODE_INHERIT
	state=0
	
func exit():
	get_tree().quit()

func end_level():
	$game.timer_stop()
	var score=$game.gameScore
	back_to_menu()
	$CanvasLayer/menu/Panel.hide()
	$CanvasLayer/menu/Control.setup(score)
