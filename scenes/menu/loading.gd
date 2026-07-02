extends Control

const rotation_arr:Array=["\\","|","/","-"]
var is_loading:bool=false

func rotate():
	for r in rotation_arr:
		$Label.text=r
		$Timer.start()
		await $Timer.timeout

func load_animation():
	while is_loading:
		await rotate()

func _ready() -> void:
	is_loading=true;
	load_animation()
