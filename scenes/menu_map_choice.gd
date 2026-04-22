extends Control



func _ready() -> void:
	hide()
	$Button.pressed.connect(test_map)
	$Button3.pressed.connect(level_0)
	
func test_map():
	get_tree().current_scene.play_game("res://scenes/test_level.tscn")

func level_0():
	pass
