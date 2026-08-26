extends Control

@export var marker_a: Marker2D
@export var marker_b: Marker2D
@export var line_color: Color = Color.WHITE
@export var line_width: float = 2.0


func _ready() -> void:
	$MenuWindow.open()

func _process(_delta):
	queue_redraw()

func _draw():
	var from = marker_a.global_position
	var to = marker_b.global_position
	draw_line(from, to, line_color, line_width)
