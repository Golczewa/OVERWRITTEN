extends Panel


func _ready() -> void:
	randomize()
	hurt()


## Shakes this panel randomly, then removes it.
func hurt(amplitude: float = 15, duration: float = 0.5, shakes: int = 6) -> void:
	var base_pos: Vector2 = global_position
	var step_time: float = duration / float(shakes)
	var tween: Tween = create_tween()
	for i: int in range(shakes):
		var current_amp: float = amplitude * (1.0 - float(i) / shakes)
		var rand_offset: Vector2 = Vector2(randf_range(-current_amp, current_amp),randf_range(-current_amp, current_amp))
		tween.tween_property(self, "global_position", base_pos + rand_offset, step_time)
	tween.tween_property(self, "global_position", base_pos, step_time)
	await tween.finished
	queue_free()
