extends PanelContainer

@export var allow_spaces: bool = false
@export var title: String = "Title"
@export var min_height:float
@onready var close_button: Button = $VBoxContainer/PanelContainer/HBoxContainer/Button
@onready var upper_panel: PanelContainer = $VBoxContainer/PanelContainer
@onready var upper_bar: Control = $VBoxContainer/PanelContainer/HBoxContainer/Control

const begin_h = 80
const anim_time = 0.1
var open := false


func _ready() -> void:
	format_title()


func open_animation():
	if not open:
		AudioPlayer.play(AudioPlayer.menu_window_open)
	show()
	open = true
	var height
	if min_height:
		height=min_height
	else:
		height = size.y
	var centre = height / 2 - 80
	print(centre)
	position.y = centre
	size.y = begin_h
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "size", Vector2(size.x, height), anim_time)
	tween.tween_property(self, "position", Vector2(position.x, 0), anim_time)
	await tween.finished


func close_animation():
	if open:
		AudioPlayer.play(AudioPlayer.menu_window_close)
	open = false
	var height = size.y
	var centre = height / 2 - 80
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "size", Vector2(size.x, begin_h), anim_time)
	tween.tween_property(self, "position", Vector2(position.x, centre), anim_time)
	await tween.finished
	hide()
	size.y = height


func format_title(text = title) -> void:
	title = text
	if not allow_spaces:
		title = title.replace(" ", "_")
	$VBoxContainer/PanelContainer/HBoxContainer/Label.text = " " + title + ".ovr"
