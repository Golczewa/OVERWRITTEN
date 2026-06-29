extends PanelContainer


@export var title:String="Title";
@onready var close_button:Button=$VBoxContainer/PanelContainer/HBoxContainer/Button;
const begin_h=80

func _ready() -> void:
	title=title.replace(" ","_")
	$VBoxContainer/PanelContainer/HBoxContainer/Label.text=" "+title+".ovr"


func open_animation():
	show()
	var height=size.y
	const anim_time=0.1
	var centre=height/2-80
	position.y=centre
	size.y=begin_h
	var tween=create_tween().set_parallel(true)
	tween.tween_property(self,"size",Vector2(size.x,height),anim_time)
	tween.tween_property(self,"position",Vector2(position.x,0),anim_time)
	await tween.finished

