extends Node



func _ready() -> void:
	$game.hide()
	$game.process_mode=Node.PROCESS_MODE_DISABLED
	$CanvasLayer/menu/Button.pressed.connect(play_game)
	
func play_game():
	$game.show()
	$game.process_mode=Node.PROCESS_MODE_INHERIT
	$CanvasLayer.hide()
	$CanvasLayer.process_mode=Node.PROCESS_MODE_DISABLED
