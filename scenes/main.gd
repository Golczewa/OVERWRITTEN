extends Node



func _ready() -> void:
	$game.hide()
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer/menu/Button.pressed.connect(play_game)
	$game/CanvasLayer/pause/Button2.pressed.connect(back_to_menu)
	
func play_game():
	$game.show()
	$game.process_mode=Node.PROCESS_MODE_INHERIT
	$game.load_level("res://scenes/test_level.tscn")
	$CanvasLayer.hide()
	$CanvasLayer.process_mode=Node.PROCESS_MODE_DISABLED

func back_to_menu():
	get_tree().paused = false
	$game.hide()
	$"game/CanvasLayer/pause".hide()
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer.show()
	$CanvasLayer.process_mode=Node.PROCESS_MODE_INHERIT
	
