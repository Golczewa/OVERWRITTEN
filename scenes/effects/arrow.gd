extends AnimatedSprite2D

@export var edge_margin: float = 40.0


func update_arrow_pos(enemy_pos: Vector2, camera: Camera2D) -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var half_size: Vector2 = (viewport_size / camera.zoom) / 2.0
	var screen_center: Vector2 = camera.get_screen_center_position()
	var screen_rect := Rect2(screen_center - half_size, half_size * 2)
	if screen_rect.has_point(enemy_pos):
		visible = false
		return
	visible = true
	var dir: Vector2 = (enemy_pos - screen_center).normalized()
	var clamp_half: Vector2 = half_size - Vector2(edge_margin, edge_margin)
	var edge_offset: Vector2 = _get_edge_position(dir, clamp_half)
	global_position = screen_center + edge_offset
	global_rotation = dir.angle()


func _get_edge_position(dir: Vector2, half_size: Vector2) -> Vector2:
	var scale_x: float = (half_size.x / abs(dir.x)) if dir.x != 0.0 else INF
	var scale_y: float = (half_size.y / abs(dir.y)) if dir.y != 0.0 else INF
	var scale_: float = min(scale_x, scale_y)
	return dir * scale_
