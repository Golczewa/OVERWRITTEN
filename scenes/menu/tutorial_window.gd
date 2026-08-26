extends Control

var border_r:Vector2
var border_l:Vector2
var marker_b: Marker2D
@export var line_color: Color = Color.WHITE
@export var line_width: float = 2.0
@export var window_pack:PackedScene = preload("res://scenes/menu/tutorial_window_2.tscn")


func setup(pos:Vector2,window_size:Vector2,end_signal:Signal):
	border_l=pos
	border_r=pos+Vector2(window_size.x,0)
	end_signal.connect(queue_free)
	$Panel.size=window_size
	spawn_window()

func _process(_delta):
	queue_redraw()


func spawn_window():
	var player:CharacterBody2D=get_tree().get_first_node_in_group("player")
	var window:MenuWindow=window_pack.instantiate()
	player.canvas.add_child(window)
	marker_b=window.marker
	window.open()
	window.panel.close_button.pressed.connect(queue_free)


func _draw():
	if marker_b:
		var half_box=(border_l+border_r)/2
		var to = marker_b.global_position
		var half_x = (half_box.x + to.x) / 2.0
		var marker_a
		if half_box.x>half_x:
			marker_a = border_l
		else :
			marker_a= border_r 
		var from = marker_a - Vector2(0,1.5)
		var point_a= Vector2(half_x,from.y)
		var point_b=Vector2(half_x,to.y)
		draw_line(from, point_a, line_color, line_width)
		draw_line(point_a, point_b, line_color, line_width)
		draw_line(point_b, to, line_color, line_width)

	
