extends Control

const rotation_arr: Array = ["\\", "|", "/", "-"]
var is_loading: bool = false


func rotate():
	for r in rotation_arr:
		$Label.text = r
		$Timer.start()
		await $Timer.timeout


func load_animation():
	show()
	is_loading = true
	while is_loading:
		await rotate()


func stop_loading():
	is_loading = false
	hide()
