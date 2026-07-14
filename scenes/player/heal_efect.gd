extends Panel


func _ready() -> void:
	heal()


func heal(dest_scale:Vector2=Vector2(0.9,0.9),anim_time:float=0.5):
	var tween=create_tween().set_parallel(true)
	tween.tween_property(self,"scale",dest_scale,anim_time)
	tween.tween_property(self,"modulate:a",0,anim_time)
	await tween.finished
	queue_free()
