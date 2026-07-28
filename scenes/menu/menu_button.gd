extends Button


func _ready() -> void:
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)


func on_mouse_entered():
	text[0] = ">"


func on_mouse_exited():
	text[0] = " "
