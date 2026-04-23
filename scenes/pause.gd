extends Control



func _ready() -> void:
	hide()
	$Button.pressed.connect(when_pressed)
	$Button3.pressed.connect(when_pressed)
	

func  _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode==KEY_ESCAPE and event.pressed:
			show()
			get_tree().paused=true

func  when_pressed():
	if get_tree().paused:
		hide()
		get_tree().paused=false
