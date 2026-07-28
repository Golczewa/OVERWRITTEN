extends Panel


func _ready() -> void:
	randomize()
	hurt()


func hurt(amplitude: float = 15, duration: float = 0.5, shakes: int = 6) -> void:
	var base_pos := global_position
	var step_time := duration / float(shakes)
	var tween := create_tween()
	for i in range(shakes):
		var current_amp := amplitude * (1.0 - float(i) / shakes)
		var rand_offset := Vector2(
			randf_range(-current_amp, current_amp), randf_range(-current_amp, current_amp)
		)
		tween.tween_property(self, "global_position", base_pos + rand_offset, step_time)
	tween.tween_property(self, "global_position", base_pos, step_time)
	await tween.finished
	queue_free()
