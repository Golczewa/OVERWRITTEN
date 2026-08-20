extends Button

var is_unlocked: bool


func setup(_name: String, img: String, unlocked: bool = true):
	is_unlocked = unlocked
	if is_unlocked:
		icon = load(img)
	else:
		disabled = true
		icon = load("res://asstets/menu/locked.png")
