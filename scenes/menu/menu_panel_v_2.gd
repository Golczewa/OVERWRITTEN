extends PanelContainer

@export var title: String = "Title"
@onready var close_button: Button = $VBoxContainer/PanelContainer/HBoxContainer/Button
const begin_h = 80
const anim_time = 0.1


func _ready() -> void:
	format_title()


func open_animation():
	show()
	var height = size.y
	var centre = height / 2 - 80
	position.y = centre
	size.y = begin_h
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self, "size", Vector2(size.x, height), anim_time)
	tween.tween_property(self, "position", Vector2(position.x, 0), anim_time)
	await tween.finished


func close_animation():
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
	title = title.replace(" ", "_")
	$VBoxContainer/PanelContainer/HBoxContainer/Label.text = " " + title + ".ovr"
