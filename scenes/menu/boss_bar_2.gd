extends Control

func _ready() -> void:
	modulate.a=0

func boss_is_in(name:String,hp:int,time=1.5)->void:
	$Label.text=name
	$TextureProgressBar.max_value=hp
	var tween=create_tween()
	$TextureProgressBar.value=0
	tween.tween_property(self,"modulate:a",1,0.5)
	tween.tween_property($TextureProgressBar,"value",hp,time)
	await tween.finished

func boss_is_out():
	modulate.a=0

func update(heath:int):
	$TextureProgressBar.value=heath