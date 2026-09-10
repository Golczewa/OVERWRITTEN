extends Button

@onready var popup: PopupMenu = $PopupMenu
@export var selected: int = 0
@export var options: Array[String]
signal chosen


func _ready() -> void:
	for option in options:
		popup.add_item(option)
	text = format_text(popup.get_item_text(selected))
	pressed.connect(_on_pressed)
	popup.index_pressed.connect(_on_item_picked)


func _on_pressed() -> void:
	var btn_rect = get_global_rect()
	popup.position = Vector2i(btn_rect.position.x, btn_rect.position.y + btn_rect.size.y)
	popup.popup()


func _on_item_picked(index: int) -> void:
	text = format_text(popup.get_item_text(index))
	selected = index
	AudioPlayer.play(AudioPlayer.menu_window_open)
	emit_signal("chosen", index)


func format_text(t: String) -> String:
	return "< " + t + " >"


func overwrite_options(o: Array[String]):
	popup.clear()
	options = o
	for option in o:
		popup.add_item(option)
	text = format_text(popup.get_item_text(selected))
