extends Control

var border_r: Vector2
var border_l: Vector2
var target: Node2D
var window_size: Vector2
@export var marker_b: Marker2D
@export var line_color: Color = Color.WHITE
@export var line_width: float = 2.0


func _ready() -> void:
	$MenuWindow.hiding.connect(queue_free)


func setup(targ: Node2D, window_size_: Vector2, end_signal: Signal, content: String):
	target = targ
	window_size = window_size_
	end_signal.connect(queue_free)
	update_positions()
	$MenuWindow/Label.text = content
	$MenuWindow.open()
	z_index = -123


func update_positions():
	var cam_scale: Vector2 = get_viewport().canvas_transform.get_scale()
	var center: Vector2 = world_to_canvas(target.global_position)
	var scaled_size: Vector2 = window_size * cam_scale
	$Panel.size = scaled_size
	$Panel.global_position = center - scaled_size / 2.0
	border_l = center - Vector2(scaled_size.x / 2.0, scaled_size.y / 2.0)
	border_r = center + Vector2(scaled_size.x / 2.0, -scaled_size.y / 2.0)


func _process(_delta):
	update_positions()
	queue_redraw()


func world_to_canvas(world_pos: Vector2) -> Vector2:
	return get_viewport().canvas_transform * world_pos


func _draw():
	if marker_b:
		var half_box = (border_l + border_r) / 2
		var to = marker_b.global_position
		var half_x = (half_box.x + to.x) / 2.0
		var marker_a
		if half_box.x > half_x:
			marker_a = border_l
		else:
			marker_a = border_r
		var from = marker_a + Vector2(0, 1.5)
		var point_a = Vector2(half_x, from.y)
		var point_b = Vector2(half_x, to.y)
		draw_line(from, point_a, line_color, line_width)
		draw_line(point_a, point_b, line_color, line_width)
		draw_line(point_b, to, line_color, line_width)
