extends Control



func _ready() -> void:
	hide()
	$Button.pressed.connect(level_setup.bind(0))
	$Button3.pressed.connect(level_setup.bind(1))
	
func level_setup(num:int):
	$Control.setup(num)
