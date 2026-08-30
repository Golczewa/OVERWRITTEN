extends PanelContainer

@export var allow_spaces: bool = false
@export var title: String = "Title"
@onready var close_button: Button = $VBoxContainer/PanelContainer/HBoxContainer/Button
@onready var upper_panel: PanelContainer = $VBoxContainer/PanelContainer
@onready var upper_bar: Control = $VBoxContainer/PanelContainer/HBoxContainer/Control

const begin_h = 80
const anim_time = 0.1


func _ready() -> void:
	format_title()


func open_animation():
	show()
	AudioPlayer.play(AudioPlayer.menu_window_open)
	var height = size.y
	var centre = height / 2 - 80
	position.y = centre
	size.y = begin_h
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "size", Vector2(size.x, height), anim_time)
	tween.tween_property(self, "position", Vector2(position.x, 0), anim_time)
	await tween.finished


func close_animation():
	AudioPlayer.play(AudioPlayer.menu_window_close)
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
