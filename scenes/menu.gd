extends Control
@onready var play=$CanvasLayer/Button

func _ready() -> void:
	play.pressed.connect(when_pressed)
	
func when_pressed():
	get_parent().load_game()
