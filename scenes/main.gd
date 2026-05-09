extends Node



func _ready() -> void:
	$game.hide()
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer/menu/Panel/Button2.pressed.connect(exit)
	$game/CanvasLayer/pause/Button2.pressed.connect(back_to_menu)
	
func play_game(path:String):
	$game.showGameUI()
	$game.process_mode=Node.PROCESS_MODE_INHERIT
	$game.load_level(path)
	$CanvasLayer.hide()
	$CanvasLayer.process_mode=Node.PROCESS_MODE_DISABLED

func back_to_menu():
	get_tree().paused = false
	$game.hideGameUI()
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer.show()
	$CanvasLayer/menu.get_main_menu()
	$CanvasLayer.process_mode=Node.PROCESS_MODE_INHERIT
	
func exit():
	get_tree().quit()
