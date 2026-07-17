extends RichTextLabel

@export var scroll_speed: float = 40.0
var scrollbar: VScrollBar
var loop_point: float = 0.0
var can_scroll: bool = false

func _ready() -> void:
	scroll_active = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	scrollbar = get_v_scroll_bar()
	scrollbar.modulate = Color(1, 1, 1, 0)
	scrollbar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var original_text = text
	text = original_text + "\n\n\n\n" + original_text
	await get_tree().process_frame
	await get_tree().process_frame
	loop_point = scrollbar.max_value / 2.0

func _process(delta: float) -> void:
	scrollbar.value += scroll_speed * delta
	if scrollbar.value >= loop_point:
		scrollbar.value -= loop_point
