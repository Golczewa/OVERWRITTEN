extends Node

var state = 0
signal menu
signal game


func _ready() -> void:
	#ConfigManager.reset_all()
	$game.hide()
	$game.process_mode = Node.PROCESS_MODE_DISABLED
	$game/CanvasLayer/pause/VBoxContainer/Button3.pressed.connect(back_to_menu)
	$game/CanvasLayer/skill_issue/VBoxContainer/Button2.pressed.connect(back_to_menu)
	$game/CanvasLayer/skill_issue/AspectRatioContainer.close_button.pressed.connect(back_to_menu)


func play_game(path: String):
	AudioPlayer.stop_music()
	AudioPlayer.stop_all_sfx()
	$CanvasLayer/loading.load_animation()
	emit_signal("game")
	$game.process_mode = Node.PROCESS_MODE_INHERIT
	$game.load_level(path)
	$CanvasLayer/loading.stop_loading()
	$CanvasLayer.hide()
	$CanvasLayer.process_mode = Node.PROCESS_MODE_DISABLED
	state = 1


func back_to_menu():
	AudioPlayer.play_music(AudioPlayer.menu_theme)
	$game/CanvasLayer/pause.is_open = false
	get_tree().paused = false
	emit_signal("menu")
	$game.process_mode = Node.PROCESS_MODE_DISABLED
	$CanvasLayer.process_mode = Node.PROCESS_MODE_INHERIT
	state = 0


func end_level():
	$game.timer_stop()
	var score = $game.gameScore
	back_to_menu()
	$CanvasLayer/menu/Control.setup(score)
