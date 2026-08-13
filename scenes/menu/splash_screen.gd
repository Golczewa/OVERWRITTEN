extends Control


func _ready() -> void:
	$Timer.start(1)
	await $Timer.timeout
	await $Control.open()
	$Timer.start(3)
	await $Timer.timeout
	await $Control.begone()
	$Timer.start(1)
	await $Timer.timeout
	get_tree().change_scene_to_file("res://scenes/main.tscn")
